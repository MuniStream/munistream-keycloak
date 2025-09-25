"""
Example FastAPI application demonstrating Keycloak integration
"""
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import os
from typing import Dict, Any

from .keycloak_provider import KeycloakAuthProvider
from .fastapi_integration import KeycloakAuth, require_roles, require_all_roles, OptionalAuth


# Initialize Keycloak provider
keycloak_provider = KeycloakAuthProvider(
    server_url=os.getenv("KEYCLOAK_URL", "http://localhost:8180"),
    realm=os.getenv("KEYCLOAK_REALM", "munistream"),
    client_id=os.getenv("KEYCLOAK_CLIENT_ID", "munistream-backend"),
    client_secret=os.getenv("KEYCLOAK_CLIENT_SECRET", "changeme-backend-secret-in-production")
)

# Create auth dependencies
auth = KeycloakAuth(keycloak_provider)
optional_auth = OptionalAuth(keycloak_provider)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager"""
    print("Starting MuniStream Backend with Keycloak Authentication")
    yield
    print("Shutting down MuniStream Backend")


# Create FastAPI app
app = FastAPI(
    title="MuniStream Backend",
    description="Backend API with Keycloak Authentication",
    version="1.0.0",
    lifespan=lifespan
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Public endpoints
@app.get("/api/v1/health")
async def health_check():
    """Health check endpoint - no authentication required"""
    return {"status": "healthy", "auth_provider": "keycloak"}


@app.get("/api/v1/public/workflows")
async def get_public_workflows(
    current_user: Dict[Any, Any] = Depends(optional_auth.get_optional_user)
):
    """
    Get public workflows - authentication optional
    Returns different data based on authentication status
    """
    if current_user:
        return {
            "workflows": ["permit_application", "license_renewal", "tax_payment"],
            "user": current_user["username"],
            "personalized": True
        }
    else:
        return {
            "workflows": ["permit_application"],
            "personalized": False
        }


# Protected endpoints
@app.get("/api/v1/user/profile")
async def get_user_profile(
    current_user: Dict[Any, Any] = Depends(auth.get_current_user)
):
    """Get current user profile - requires authentication"""
    return {
        "username": current_user["username"],
        "email": current_user["email"],
        "name": current_user["name"],
        "roles": current_user["roles"],
        "email_verified": current_user["email_verified"]
    }


# Role-based endpoints
@app.get("/api/v1/admin/users")
async def list_users(
    current_user: Dict[Any, Any] = Depends(require_roles(["admin"]))
):
    """List all users - requires admin role"""
    return {
        "users": [],
        "total": 0,
        "page": 1,
        "admin": current_user["username"]
    }


@app.post("/api/v1/workflows/{workflow_id}/approve")
async def approve_workflow(
    workflow_id: str,
    current_user: Dict[Any, Any] = Depends(require_roles(["approver", "admin"]))
):
    """Approve workflow - requires approver or admin role"""
    return {
        "workflow_id": workflow_id,
        "status": "approved",
        "approved_by": current_user["username"]
    }


@app.get("/api/v1/documents/review")
async def get_documents_for_review(
    current_user: Dict[Any, Any] = Depends(require_roles(["reviewer", "manager", "admin"]))
):
    """Get documents for review - requires reviewer, manager, or admin role"""
    return {
        "documents": [],
        "reviewer": current_user["username"]
    }


@app.post("/api/v1/admin/system/config")
async def update_system_config(
    config: Dict[Any, Any],
    current_user: Dict[Any, Any] = Depends(require_all_roles(["admin", "manager"]))
):
    """Update system configuration - requires both admin AND manager roles"""
    return {
        "config": config,
        "updated_by": current_user["username"],
        "status": "updated"
    }


# Citizen-specific endpoints
@app.get("/api/v1/citizen/applications")
async def get_my_applications(
    current_user: Dict[Any, Any] = Depends(require_roles(["citizen", "verified_citizen"]))
):
    """Get citizen's applications - requires citizen role"""
    return {
        "applications": [],
        "citizen": current_user["username"]
    }


@app.post("/api/v1/citizen/submit-document")
async def submit_document(
    document_type: str,
    current_user: Dict[Any, Any] = Depends(require_roles(["verified_citizen"]))
):
    """Submit document - requires verified citizen role"""
    return {
        "document_type": document_type,
        "submitted_by": current_user["username"],
        "status": "submitted"
    }


# Business entity endpoints
@app.get("/api/v1/business/permits")
async def get_business_permits(
    current_user: Dict[Any, Any] = Depends(require_roles(["business_entity"]))
):
    """Get business permits - requires business entity role"""
    return {
        "permits": [],
        "business": current_user["username"]
    }


# Token management endpoints
@app.post("/api/v1/auth/refresh")
async def refresh_token(refresh_token: str):
    """Refresh access token"""
    try:
        token_response = await keycloak_provider.refresh_token(refresh_token)
        return token_response
    except Exception as e:
        raise HTTPException(
            status_code=401,
            detail="Invalid refresh token"
        )


@app.post("/api/v1/auth/logout")
async def logout(
    refresh_token: str,
    current_user: Dict[Any, Any] = Depends(auth.get_current_user)
):
    """Logout and revoke tokens"""
    try:
        await keycloak_provider.logout(refresh_token)
        return {"message": "Logged out successfully"}
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail="Logout failed"
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)