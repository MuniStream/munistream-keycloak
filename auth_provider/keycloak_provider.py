"""
Keycloak Authentication Provider for MuniStream Backend
"""
from typing import Optional, Dict, Any, List
from datetime import datetime, timedelta
import httpx
from jose import jwt, JWTError
import logging

logger = logging.getLogger(__name__)


class KeycloakAuthProvider:
    """
    Keycloak authentication provider implementing OAuth 2.0/OIDC
    """

    def __init__(
        self,
        server_url: str,
        realm: str,
        client_id: str,
        client_secret: Optional[str] = None,
        verify_ssl: bool = True
    ):
        """
        Initialize Keycloak authentication provider

        Args:
            server_url: Keycloak server URL (e.g., http://localhost:8180)
            realm: Keycloak realm name
            client_id: Client ID for backend service
            client_secret: Client secret for confidential clients
            verify_ssl: Whether to verify SSL certificates
        """
        self.server_url = server_url.rstrip('/')
        self.realm = realm
        self.client_id = client_id
        self.client_secret = client_secret
        self.verify_ssl = verify_ssl

        # Build endpoints
        self.realm_url = f"{self.server_url}/realms/{realm}"
        self.token_endpoint = f"{self.realm_url}/protocol/openid-connect/token"
        self.userinfo_endpoint = f"{self.realm_url}/protocol/openid-connect/userinfo"
        self.introspect_endpoint = f"{self.realm_url}/protocol/openid-connect/token/introspect"
        self.logout_endpoint = f"{self.realm_url}/protocol/openid-connect/logout"
        self.jwks_uri = f"{self.realm_url}/protocol/openid-connect/certs"

        # Cache for JWKS
        self._jwks_cache = None
        self._jwks_cache_time = None
        self._jwks_cache_duration = timedelta(hours=1)

    async def get_jwks(self) -> Dict[str, Any]:
        """
        Get JSON Web Key Set from Keycloak
        """
        now = datetime.utcnow()
        if (self._jwks_cache is None or
            self._jwks_cache_time is None or
            now - self._jwks_cache_time > self._jwks_cache_duration):

            async with httpx.AsyncClient(verify=self.verify_ssl) as client:
                response = await client.get(self.jwks_uri)
                response.raise_for_status()
                self._jwks_cache = response.json()
                self._jwks_cache_time = now

        return self._jwks_cache

    async def verify_token(self, token: str) -> Dict[str, Any]:
        """
        Verify and decode a JWT token

        Args:
            token: JWT access token

        Returns:
            Decoded token claims

        Raises:
            JWTError: If token is invalid
        """
        # Get JWKS for verification
        jwks = await self.get_jwks()

        # Decode and verify token
        unverified_header = jwt.get_unverified_header(token)

        rsa_key = {}
        for key in jwks["keys"]:
            if key["kid"] == unverified_header["kid"]:
                rsa_key = {
                    "kty": key["kty"],
                    "kid": key["kid"],
                    "use": key["use"],
                    "n": key["n"],
                    "e": key["e"]
                }
                break

        if not rsa_key:
            raise JWTError("Unable to find appropriate key")

        payload = jwt.decode(
            token,
            rsa_key,
            algorithms=["RS256"],
            audience=self.client_id,
            issuer=self.realm_url
        )

        return payload

    async def introspect_token(self, token: str) -> Dict[str, Any]:
        """
        Introspect a token to check if it's active

        Args:
            token: Access token to introspect

        Returns:
            Token introspection response
        """
        async with httpx.AsyncClient(verify=self.verify_ssl) as client:
            response = await client.post(
                self.introspect_endpoint,
                data={
                    "token": token,
                    "client_id": self.client_id,
                    "client_secret": self.client_secret
                }
            )
            response.raise_for_status()
            return response.json()

    async def exchange_code_for_token(
        self,
        code: str,
        redirect_uri: str,
        code_verifier: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Exchange authorization code for access token

        Args:
            code: Authorization code
            redirect_uri: Redirect URI used in authorization request
            code_verifier: PKCE code verifier (for public clients)

        Returns:
            Token response with access_token, refresh_token, etc.
        """
        data = {
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirect_uri,
            "client_id": self.client_id
        }

        if self.client_secret:
            data["client_secret"] = self.client_secret

        if code_verifier:
            data["code_verifier"] = code_verifier

        async with httpx.AsyncClient(verify=self.verify_ssl) as client:
            response = await client.post(
                self.token_endpoint,
                data=data
            )
            response.raise_for_status()
            return response.json()

    async def refresh_token(self, refresh_token: str) -> Dict[str, Any]:
        """
        Refresh access token using refresh token

        Args:
            refresh_token: Refresh token

        Returns:
            New token response
        """
        data = {
            "grant_type": "refresh_token",
            "refresh_token": refresh_token,
            "client_id": self.client_id
        }

        if self.client_secret:
            data["client_secret"] = self.client_secret

        async with httpx.AsyncClient(verify=self.verify_ssl) as client:
            response = await client.post(
                self.token_endpoint,
                data=data
            )
            response.raise_for_status()
            return response.json()

    async def get_user_info(self, access_token: str) -> Dict[str, Any]:
        """
        Get user information from access token

        Args:
            access_token: Valid access token

        Returns:
            User information
        """
        async with httpx.AsyncClient(verify=self.verify_ssl) as client:
            response = await client.get(
                self.userinfo_endpoint,
                headers={"Authorization": f"Bearer {access_token}"}
            )
            response.raise_for_status()
            return response.json()

    async def logout(
        self,
        refresh_token: str,
        redirect_uri: Optional[str] = None
    ) -> None:
        """
        Logout user and revoke tokens

        Args:
            refresh_token: Refresh token to revoke
            redirect_uri: Optional redirect URI after logout
        """
        data = {
            "client_id": self.client_id,
            "refresh_token": refresh_token
        }

        if self.client_secret:
            data["client_secret"] = self.client_secret

        if redirect_uri:
            data["redirect_uri"] = redirect_uri

        async with httpx.AsyncClient(verify=self.verify_ssl) as client:
            response = await client.post(
                self.logout_endpoint,
                data=data
            )
            response.raise_for_status()

    def get_authorization_url(
        self,
        redirect_uri: str,
        state: Optional[str] = None,
        scope: str = "openid profile email",
        code_challenge: Optional[str] = None,
        code_challenge_method: str = "S256"
    ) -> str:
        """
        Build authorization URL for OAuth flow

        Args:
            redirect_uri: Redirect URI after authorization
            state: Optional state parameter
            scope: OAuth scopes
            code_challenge: PKCE code challenge
            code_challenge_method: PKCE method (S256)

        Returns:
            Authorization URL
        """
        params = {
            "client_id": self.client_id,
            "response_type": "code",
            "redirect_uri": redirect_uri,
            "scope": scope
        }

        if state:
            params["state"] = state

        if code_challenge:
            params["code_challenge"] = code_challenge
            params["code_challenge_method"] = code_challenge_method

        query_string = "&".join(f"{k}={v}" for k, v in params.items())
        return f"{self.realm_url}/protocol/openid-connect/auth?{query_string}"

    def extract_roles(self, token_claims: Dict[str, Any]) -> List[str]:
        """
        Extract roles from token claims

        Args:
            token_claims: Decoded token claims

        Returns:
            List of role names
        """
        roles = []

        # Extract realm roles
        if "realm_access" in token_claims:
            roles.extend(token_claims["realm_access"].get("roles", []))

        # Extract client roles
        if "resource_access" in token_claims:
            if self.client_id in token_claims["resource_access"]:
                client_roles = token_claims["resource_access"][self.client_id].get("roles", [])
                roles.extend(client_roles)

        return list(set(roles))  # Remove duplicates