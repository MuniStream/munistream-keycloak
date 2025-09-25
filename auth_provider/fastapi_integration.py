"""
FastAPI integration for Keycloak authentication
"""
from typing import Optional, List, Callable
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError
import logging

from .keycloak_provider import KeycloakAuthProvider

logger = logging.getLogger(__name__)

# Security scheme for Swagger UI
security_scheme = HTTPBearer()


class KeycloakAuth:
    """
    FastAPI dependency for Keycloak authentication
    """

    def __init__(self, provider: KeycloakAuthProvider):
        self.provider = provider

    async def get_current_user(
        self,
        credentials: HTTPAuthorizationCredentials = Depends(security_scheme)
    ) -> dict:
        """
        Verify token and return current user

        Args:
            credentials: Bearer token from request

        Returns:
            User information from token

        Raises:
            HTTPException: If authentication fails
        """
        if not credentials:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Authorization header missing",
                headers={"WWW-Authenticate": "Bearer"},
            )

        try:
            # Verify token
            token_claims = await self.provider.verify_token(credentials.credentials)

            # Check if token is active
            introspection = await self.provider.introspect_token(credentials.credentials)
            if not introspection.get("active"):
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token is not active",
                    headers={"WWW-Authenticate": "Bearer"},
                )

            # Extract user information
            user_info = {
                "sub": token_claims.get("sub"),
                "email": token_claims.get("email"),
                "username": token_claims.get("preferred_username"),
                "name": token_claims.get("name"),
                "roles": self.provider.extract_roles(token_claims),
                "email_verified": token_claims.get("email_verified", False),
                "token_claims": token_claims
            }

            return user_info

        except JWTError as e:
            logger.error(f"JWT verification failed: {e}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication token",
                headers={"WWW-Authenticate": "Bearer"},
            )
        except Exception as e:
            logger.error(f"Authentication error: {e}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Authentication service error"
            )


def require_roles(required_roles: List[str]) -> Callable:
    """
    Dependency to require specific roles

    Args:
        required_roles: List of required role names

    Returns:
        FastAPI dependency
    """
    async def role_checker(
        current_user: dict = Depends(KeycloakAuth.get_current_user)
    ) -> dict:
        user_roles = current_user.get("roles", [])

        # Check if user has any of the required roles
        if not any(role in user_roles for role in required_roles):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Insufficient permissions. Required roles: {', '.join(required_roles)}"
            )

        return current_user

    return role_checker


def require_all_roles(required_roles: List[str]) -> Callable:
    """
    Dependency to require all specified roles

    Args:
        required_roles: List of required role names

    Returns:
        FastAPI dependency
    """
    async def role_checker(
        current_user: dict = Depends(KeycloakAuth.get_current_user)
    ) -> dict:
        user_roles = current_user.get("roles", [])

        # Check if user has all required roles
        if not all(role in user_roles for role in required_roles):
            missing_roles = [role for role in required_roles if role not in user_roles]
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Missing required roles: {', '.join(missing_roles)}"
            )

        return current_user

    return role_checker


class OptionalAuth:
    """
    Optional authentication - allows both authenticated and anonymous access
    """

    def __init__(self, provider: KeycloakAuthProvider):
        self.provider = provider

    async def get_optional_user(
        self,
        credentials: Optional[HTTPAuthorizationCredentials] = Depends(
            HTTPBearer(auto_error=False)
        )
    ) -> Optional[dict]:
        """
        Optionally verify token if present

        Args:
            credentials: Optional bearer token

        Returns:
            User information if authenticated, None otherwise
        """
        if not credentials:
            return None

        try:
            token_claims = await self.provider.verify_token(credentials.credentials)
            return {
                "sub": token_claims.get("sub"),
                "email": token_claims.get("email"),
                "username": token_claims.get("preferred_username"),
                "name": token_claims.get("name"),
                "roles": self.provider.extract_roles(token_claims),
                "email_verified": token_claims.get("email_verified", False),
                "token_claims": token_claims
            }
        except Exception as e:
            logger.warning(f"Optional auth failed: {e}")
            return None