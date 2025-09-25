# MuniStream Keycloak Authentication Service

Keycloak authentication service for the MuniStream platform, providing OAuth 2.0/OIDC authentication with SSO support.

## Quick Start

### 1. Setup Environment

```bash
# Copy environment file and configure
cp .env.example .env

# Edit .env file with your configuration
# Important: Change default passwords in production!
```

### 2. Start Services

```bash
# Start Keycloak and PostgreSQL
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f keycloak
```

### 3. Access Keycloak

- Admin Console: http://localhost:8080
- Default credentials: admin / admin123 (change in .env)

## Architecture

- **Keycloak**: Open-source identity and access management
- **PostgreSQL**: Database for Keycloak data
- **Realm**: `munistream` - Contains all configuration
- **Clients**:
  - `munistream-admin`: Admin portal (public client)
  - `munistream-citizen`: Citizen portal (public client)
  - `munistream-backend`: Backend services (confidential client)

## User Roles

### Admin Roles
- `admin`: Full system access
- `manager`: Workflow management
- `reviewer`: Document review
- `approver`: Approval permissions
- `viewer`: Read-only access

### Citizen Roles
- `citizen`: Basic citizen user
- `verified_citizen`: Verified identity
- `business_entity`: Business accounts

## User Migration

To migrate existing users from MongoDB:

```bash
# Install Python dependencies
cd scripts
pip install -r requirements.txt

# Run migration
python migrate-users.py
```

Default temporary password for migrated users: `ChangeMe123!`

## Common Commands

```bash
# Stop services
docker-compose down

# Clean everything (including data)
docker-compose down -v

# Check health
curl http://localhost:8080/health/ready

# View realm configuration
curl http://localhost:8080/realms/munistream/.well-known/openid-configuration
```

## Configuration Files

- `docker-compose.yml`: Docker services configuration
- `.env`: Environment variables
- `realms/munistream-realm.json`: Realm configuration
- `scripts/migrate-users.py`: User migration script

## Integration

### Backend Integration

Configure your backend with:
```env
AUTH_PROVIDER=keycloak
KEYCLOAK_URL=http://localhost:8080
KEYCLOAK_REALM=munistream
KEYCLOAK_CLIENT_ID=munistream-backend
KEYCLOAK_CLIENT_SECRET=<from-keycloak-console>
```

### Frontend Integration

For React applications:
```javascript
const keycloak = new Keycloak({
  url: 'http://localhost:8080',
  realm: 'munistream',
  clientId: 'munistream-admin' // or 'munistream-citizen'
});
```

## Troubleshooting

### Keycloak not starting
- Check logs: `docker-compose logs keycloak`
- Verify PostgreSQL is running: `docker-compose ps`
- Check port 8080 is not in use: `lsof -i :8080`

### Cannot access admin console
- Wait for Keycloak to fully start (30-60 seconds)
- Check health: `curl http://localhost:8080/health/ready`
- Verify credentials in .env file

### Migration fails
- Verify MongoDB is accessible
- Check MONGODB_URI in .env
- Verify Keycloak is running
- Check realm exists: `curl http://localhost:8080/realms/munistream`

## Security Considerations

1. **Change default passwords** in production
2. **Use HTTPS** in production (configure KC_HOSTNAME)
3. **Configure proper CORS** for production domains
4. **Enable brute force protection** (enabled by default)
5. **Configure email** for password recovery

## Related Repositories

- [munistream-workflow](https://github.com/MuniStream/munistream-workflow) - Backend API
- [munistream-admin-frontend](https://github.com/MuniStream/munistream-admin-frontend) - Admin Portal
- [munistream-citizen-portal](https://github.com/MuniStream/munistream-citizen-portal) - Citizen Portal

## Support

For issues, check:
1. This README
2. [docs/SETUP.md](docs/SETUP.md) - Detailed setup guide
3. [docs/MIGRATION.md](docs/MIGRATION.md) - Migration guide
4. GitHub Issues