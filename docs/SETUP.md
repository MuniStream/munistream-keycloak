# Detailed Setup Guide

This guide provides detailed instructions for setting up Keycloak for MuniStream.

## Prerequisites

- Docker and Docker Compose installed
- Port 8080 available (Keycloak)
- Port 5433 available (PostgreSQL)
- Python 3.8+ (for migration scripts)

## Step 1: Environment Configuration

### Required Environment Variables

Create a `.env` file with the following variables:

```env
# Keycloak Admin
KEYCLOAK_ADMIN=admin                  # Admin username
KEYCLOAK_ADMIN_PASSWORD=changeme123   # Admin password (CHANGE THIS!)

# Database
KC_DB_PASSWORD=keycloak_secure_pass   # Database password (CHANGE THIS!)
KC_DB_PORT=5433                       # Database port (avoid conflicts)

# Keycloak Ports
KC_HTTP_PORT=8080                     # HTTP port
KC_HTTPS_PORT=8443                    # HTTPS port (for production)

# Logging
KC_LOG_LEVEL=INFO                     # Options: ERROR, WARN, INFO, DEBUG
KC_LOG_CONSOLE_OUTPUT=default         # Options: default, json

# Email Configuration (Optional)
KEYCLOAK_SMTP_HOST=smtp.gmail.com
KEYCLOAK_SMTP_PORT=587
KEYCLOAK_SMTP_FROM=noreply@munistream.com
KEYCLOAK_SMTP_USER=your-email@gmail.com
KEYCLOAK_SMTP_PASSWORD=your-app-password

# Migration
MONGODB_URI=mongodb://admin:munistream123@localhost:27017/munistream?authSource=admin
MIGRATION_BATCH_SIZE=100
```

### Security Considerations

1. **Passwords**: Never use default passwords in production
2. **Network**: In production, don't expose PostgreSQL port
3. **HTTPS**: Configure SSL certificates for production

## Step 2: Directory Structure

Create the required directories:

```bash
mkdir -p realms themes/munistream-admin themes/munistream-citizen providers scripts docs
```

## Step 3: Start Services

### Initial Start

```bash
# Start services in background
docker-compose up -d

# Wait for Keycloak to be ready (30-60 seconds)
# Check health status
curl http://localhost:8080/health/ready
```

### Verify Services

```bash
# Check running containers
docker-compose ps

# Expected output:
NAME                      STATUS          PORTS
munistream-keycloak       Up (healthy)    0.0.0.0:8080->8080/tcp
munistream-keycloak-db    Up (healthy)    0.0.0.0:5433->5432/tcp
```

## Step 4: Access Keycloak Admin Console

1. Open browser: http://localhost:8080
2. Click "Administration Console"
3. Login with admin credentials from .env

## Step 5: Realm Configuration

The realm is automatically imported on first start from `realms/munistream-realm.json`.

### Verify Realm Setup

1. In Admin Console, check realm dropdown shows "munistream"
2. Navigate to Clients - verify 3 clients exist:
   - munistream-admin
   - munistream-citizen
   - munistream-backend
3. Navigate to Realm Roles - verify roles exist:
   - admin, manager, reviewer, approver, viewer
   - citizen, verified_citizen, business_entity

### Manual Realm Import (if needed)

```bash
# Copy realm file to container
docker cp realms/munistream-realm.json munistream-keycloak:/tmp/

# Import realm
docker exec munistream-keycloak \
  /opt/keycloak/bin/kc.sh import --file /tmp/munistream-realm.json
```

## Step 6: Configure Clients

### Backend Client Secret

1. Navigate to Clients → munistream-backend
2. Go to Credentials tab
3. Copy the Secret value
4. Update your backend .env:
   ```env
   KEYCLOAK_CLIENT_SECRET=<copied-secret>
   ```

### Frontend Clients

Public clients (munistream-admin, munistream-citizen) don't need secrets but use PKCE.

## Step 7: User Migration

### Install Dependencies

```bash
cd scripts
pip install -r requirements.txt
```

### Run Migration

```bash
python migrate-users.py
```

The script will:
1. Connect to MongoDB and Keycloak
2. Migrate admin users from `users` collection
3. Migrate citizens from `customers` collection
4. Assign appropriate roles
5. Set temporary passwords

### Post-Migration

All migrated users get temporary password: `ChangeMe123!`

Users must change password on first login.

## Step 8: Testing

### Test Authentication Flow

1. Get access token:
```bash
curl -X POST http://localhost:8080/realms/munistream/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=munistream-backend" \
  -d "client_secret=<your-secret>" \
  -d "grant_type=client_credentials"
```

2. Verify token:
```bash
curl http://localhost:8080/realms/munistream/protocol/openid-connect/userinfo \
  -H "Authorization: Bearer <access-token>"
```

### Test User Login

1. Create test user in Admin Console
2. Set password
3. Test login with curl or frontend application

## Step 9: Production Considerations

### SSL/TLS Configuration

For production, configure HTTPS:

1. Update docker-compose.yml:
```yaml
environment:
  KC_HOSTNAME: your-domain.com
  KC_HOSTNAME_STRICT_HTTPS: true
  KC_PROXY: edge
```

2. Use reverse proxy (nginx/traefik) with SSL certificates

### High Availability

For production HA setup:
1. Use external PostgreSQL cluster
2. Run multiple Keycloak instances
3. Configure session replication

### Backup Strategy

```bash
# Backup realm configuration
docker exec munistream-keycloak \
  /opt/keycloak/bin/kc.sh export --dir /opt/keycloak/data/export --realm munistream

# Backup database
docker exec munistream-keycloak-db \
  pg_dump -U keycloak keycloak > backup.sql
```

## Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Check what's using port 8080
lsof -i :8080

# Change port in .env:
KC_HTTP_PORT=8081
```

#### Database Connection Failed
```bash
# Check database logs
docker-compose logs keycloak-db

# Verify database is running
docker exec munistream-keycloak-db pg_isready
```

#### Realm Not Found
```bash
# Re-import realm
docker-compose down
docker-compose up -d
# Realm auto-imports on fresh start
```

#### Memory Issues
Add to docker-compose.yml:
```yaml
services:
  keycloak:
    environment:
      JAVA_OPTS: "-Xms512m -Xmx2048m"
```

## Next Steps

1. [Configure Backend Integration](https://github.com/MuniStream/munistream-workflow/issues/6)
2. [Configure Admin Portal](https://github.com/MuniStream/munistream-admin-frontend/issues/1)
3. [Configure Citizen Portal](https://github.com/MuniStream/munistream-citizen-portal/issues/1)