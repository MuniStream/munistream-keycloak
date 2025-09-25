#!/usr/bin/env python3
"""
Migration script to transfer users from MongoDB to Keycloak.
Migrates both admin users and citizen customers.
"""

import os
import sys
import logging
from typing import Dict, List, Optional
from datetime import datetime

from pymongo import MongoClient
from keycloak import KeycloakAdmin, KeycloakOpenIDConnection
from keycloak.exceptions import KeycloakGetError, KeycloakPostError
from dotenv import load_dotenv

# Load environment variables
load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Configuration
KEYCLOAK_URL = os.getenv('KEYCLOAK_URL', 'http://localhost:8080')
KEYCLOAK_REALM = os.getenv('KEYCLOAK_REALM', 'munistream')
KEYCLOAK_ADMIN_USER = os.getenv('KEYCLOAK_ADMIN', 'admin')
KEYCLOAK_ADMIN_PASSWORD = os.getenv('KEYCLOAK_ADMIN_PASSWORD', 'admin123')
MONGODB_URI = os.getenv('MONGODB_URI', 'mongodb://admin:munistream123@localhost:27017/munistream?authSource=admin')
BATCH_SIZE = int(os.getenv('MIGRATION_BATCH_SIZE', '100'))

# Role mapping from MongoDB to Keycloak
ADMIN_ROLE_MAPPING = {
    'admin': ['admin'],
    'manager': ['manager'],
    'reviewer': ['reviewer'],
    'approver': ['approver'],
    'viewer': ['viewer']
}

CUSTOMER_ROLE_MAPPING = {
    'active': ['citizen'],
    'verified': ['verified_citizen'],
    'business': ['business_entity']
}


class UserMigrator:
    """Handles migration of users from MongoDB to Keycloak"""

    def __init__(self):
        """Initialize connections to MongoDB and Keycloak"""
        # MongoDB connection
        self.mongo_client = MongoClient(MONGODB_URI)
        self.db = self.mongo_client['munistream']

        # Keycloak connection
        keycloak_connection = KeycloakOpenIDConnection(
            server_url=KEYCLOAK_URL,
            username=KEYCLOAK_ADMIN_USER,
            password=KEYCLOAK_ADMIN_PASSWORD,
            verify=True
        )

        self.keycloak_admin = KeycloakAdmin(connection=keycloak_connection)
        self.keycloak_admin.realm_name = KEYCLOAK_REALM

        # Statistics
        self.stats = {
            'users_processed': 0,
            'users_created': 0,
            'users_updated': 0,
            'users_failed': 0,
            'customers_processed': 0,
            'customers_created': 0,
            'customers_updated': 0,
            'customers_failed': 0
        }

    def migrate_admin_users(self):
        """Migrate admin users from users collection"""
        logger.info("Starting admin users migration...")

        users_collection = self.db['users']
        total_users = users_collection.count_documents({})
        logger.info(f"Found {total_users} admin users to migrate")

        batch = []
        for user in users_collection.find():
            batch.append(user)

            if len(batch) >= BATCH_SIZE:
                self._process_admin_batch(batch)
                batch = []

        # Process remaining users
        if batch:
            self._process_admin_batch(batch)

        logger.info(f"Admin users migration completed: {self.stats['users_created']} created, "
                   f"{self.stats['users_updated']} updated, {self.stats['users_failed']} failed")

    def migrate_customers(self):
        """Migrate customers from customers collection"""
        logger.info("Starting customers migration...")

        customers_collection = self.db['customers']
        total_customers = customers_collection.count_documents({})
        logger.info(f"Found {total_customers} customers to migrate")

        batch = []
        for customer in customers_collection.find():
            batch.append(customer)

            if len(batch) >= BATCH_SIZE:
                self._process_customer_batch(batch)
                batch = []

        # Process remaining customers
        if batch:
            self._process_customer_batch(batch)

        logger.info(f"Customers migration completed: {self.stats['customers_created']} created, "
                   f"{self.stats['customers_updated']} updated, {self.stats['customers_failed']} failed")

    def _process_admin_batch(self, users: List[Dict]):
        """Process a batch of admin users"""
        for user in users:
            self.stats['users_processed'] += 1

            try:
                # Prepare user data for Keycloak
                keycloak_user = {
                    'username': user.get('username'),
                    'email': user.get('email'),
                    'firstName': user.get('full_name', '').split(' ')[0] if user.get('full_name') else '',
                    'lastName': ' '.join(user.get('full_name', '').split(' ')[1:]) if user.get('full_name') else '',
                    'enabled': user.get('status') == 'active',
                    'emailVerified': True,
                    'attributes': {
                        'department': user.get('department', ''),
                        'phone': user.get('phone', ''),
                        'original_id': str(user.get('_id')),
                        'migrated_from': 'mongodb_users',
                        'migration_date': datetime.utcnow().isoformat()
                    }
                }

                # Check if user exists
                existing_user = self._get_user_by_username(user.get('username'))

                if existing_user:
                    # Update existing user
                    self.keycloak_admin.update_user(existing_user['id'], keycloak_user)
                    self.stats['users_updated'] += 1
                    logger.debug(f"Updated user: {user.get('username')}")
                else:
                    # Create new user
                    user_id = self.keycloak_admin.create_user(keycloak_user)

                    # Set temporary password
                    self.keycloak_admin.set_user_password(
                        user_id=user_id,
                        password="ChangeMe123!",
                        temporary=True
                    )

                    self.stats['users_created'] += 1
                    logger.debug(f"Created user: {user.get('username')}")
                    existing_user = {'id': user_id}

                # Assign roles
                role = user.get('role')
                if role in ADMIN_ROLE_MAPPING:
                    for keycloak_role in ADMIN_ROLE_MAPPING[role]:
                        try:
                            role_obj = self.keycloak_admin.get_realm_role(keycloak_role)
                            self.keycloak_admin.assign_realm_roles(
                                user_id=existing_user['id'],
                                roles=[role_obj]
                            )
                        except Exception as e:
                            logger.warning(f"Could not assign role {keycloak_role} to user {user.get('username')}: {e}")

            except Exception as e:
                self.stats['users_failed'] += 1
                logger.error(f"Failed to migrate user {user.get('username')}: {e}")

    def _process_customer_batch(self, customers: List[Dict]):
        """Process a batch of customers"""
        for customer in customers:
            self.stats['customers_processed'] += 1

            try:
                # Prepare customer data for Keycloak
                keycloak_user = {
                    'username': customer.get('email'),  # Use email as username for customers
                    'email': customer.get('email'),
                    'firstName': customer.get('full_name', '').split(' ')[0] if customer.get('full_name') else '',
                    'lastName': ' '.join(customer.get('full_name', '').split(' ')[1:]) if customer.get('full_name') else '',
                    'enabled': customer.get('status') == 'active',
                    'emailVerified': customer.get('email_verified', False),
                    'attributes': {
                        'document_number': customer.get('document_number', ''),
                        'phone': customer.get('phone', ''),
                        'entity_type': 'business' if customer.get('is_business') else 'individual',
                        'verification_status': 'verified' if customer.get('email_verified') else 'pending',
                        'original_id': str(customer.get('_id')),
                        'migrated_from': 'mongodb_customers',
                        'migration_date': datetime.utcnow().isoformat()
                    }
                }

                # Check if user exists
                existing_user = self._get_user_by_email(customer.get('email'))

                if existing_user:
                    # Update existing user
                    self.keycloak_admin.update_user(existing_user['id'], keycloak_user)
                    self.stats['customers_updated'] += 1
                    logger.debug(f"Updated customer: {customer.get('email')}")
                else:
                    # Create new user
                    user_id = self.keycloak_admin.create_user(keycloak_user)

                    # Set temporary password
                    self.keycloak_admin.set_user_password(
                        user_id=user_id,
                        password="ChangeMe123!",
                        temporary=True
                    )

                    self.stats['customers_created'] += 1
                    logger.debug(f"Created customer: {customer.get('email')}")
                    existing_user = {'id': user_id}

                # Assign citizen role
                try:
                    if customer.get('email_verified'):
                        role_name = 'verified_citizen'
                    else:
                        role_name = 'citizen'

                    role_obj = self.keycloak_admin.get_realm_role(role_name)
                    self.keycloak_admin.assign_realm_roles(
                        user_id=existing_user['id'],
                        roles=[role_obj]
                    )
                except Exception as e:
                    logger.warning(f"Could not assign role to customer {customer.get('email')}: {e}")

            except Exception as e:
                self.stats['customers_failed'] += 1
                logger.error(f"Failed to migrate customer {customer.get('email')}: {e}")

    def _get_user_by_username(self, username: str) -> Optional[Dict]:
        """Get user by username from Keycloak"""
        try:
            users = self.keycloak_admin.get_users({'username': username, 'exact': True})
            return users[0] if users else None
        except KeycloakGetError:
            return None

    def _get_user_by_email(self, email: str) -> Optional[Dict]:
        """Get user by email from Keycloak"""
        try:
            users = self.keycloak_admin.get_users({'email': email, 'exact': True})
            return users[0] if users else None
        except KeycloakGetError:
            return None

    def print_summary(self):
        """Print migration summary"""
        print("\n" + "="*50)
        print("MIGRATION SUMMARY")
        print("="*50)
        print(f"Admin Users:")
        print(f"  Processed: {self.stats['users_processed']}")
        print(f"  Created: {self.stats['users_created']}")
        print(f"  Updated: {self.stats['users_updated']}")
        print(f"  Failed: {self.stats['users_failed']}")
        print(f"\nCustomers:")
        print(f"  Processed: {self.stats['customers_processed']}")
        print(f"  Created: {self.stats['customers_created']}")
        print(f"  Updated: {self.stats['customers_updated']}")
        print(f"  Failed: {self.stats['customers_failed']}")
        print("="*50)


def main():
    """Main migration function"""
    logger.info("Starting MuniStream user migration to Keycloak...")

    # Verify connections
    try:
        migrator = UserMigrator()

        # Test Keycloak connection
        realm_info = migrator.keycloak_admin.get_realm(KEYCLOAK_REALM)
        logger.info(f"Connected to Keycloak realm: {realm_info['realm']}")

        # Test MongoDB connection
        db_info = migrator.db.command('serverStatus')
        logger.info(f"Connected to MongoDB version: {db_info['version']}")

    except Exception as e:
        logger.error(f"Failed to establish connections: {e}")
        sys.exit(1)

    # Run migrations
    try:
        migrator.migrate_admin_users()
        migrator.migrate_customers()
        migrator.print_summary()

    except Exception as e:
        logger.error(f"Migration failed: {e}")
        sys.exit(1)

    logger.info("Migration completed successfully!")


if __name__ == "__main__":
    main()