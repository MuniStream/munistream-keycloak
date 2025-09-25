"""
MuniStream Keycloak Authentication Provider
"""
from .keycloak_provider import KeycloakAuthProvider
from .fastapi_integration import (
    KeycloakAuth,
    OptionalAuth,
    require_roles,
    require_all_roles,
    security_scheme
)

__all__ = [
    "KeycloakAuthProvider",
    "KeycloakAuth",
    "OptionalAuth",
    "require_roles",
    "require_all_roles",
    "security_scheme"
]

__version__ = "1.0.0"