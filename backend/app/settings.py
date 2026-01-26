import os
from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import HTMLResponse
from pathlib import Path
from pydantic import BaseModel

router = APIRouter()

# Path to common prompts file
COMMON_PROMPTS_FILE = os.path.join("prompts", "common.txt")
USER_PROFILE_FILE = os.path.join("prompts", "user_profile.txt")

class UserProfileUpdate(BaseModel):
    about_you: str

@router.get("/settings", response_class=HTMLResponse)
async def get_settings_page():
    """Serves the settings page."""
    return HTMLResponse(content=Path("temp/settings.html").read_text())

@router.get("/api/settings/profile")
async def get_user_profile():
    """Returns the current user profile from user_profile.txt"""
    about_you = ""
    if os.path.exists(USER_PROFILE_FILE):
        try:
            with open(USER_PROFILE_FILE, "r", encoding="utf-8") as f:
                about_you = f.read().strip()
        except Exception as e:
            print(f"Error reading user profile: {e}")
    
    return {"about_you": about_you}

@router.post("/api/settings/profile")
async def update_user_profile(data: UserProfileUpdate):
    """Updates the user profile and appends to common.txt"""
    try:
        # Save user profile to dedicated file
        with open(USER_PROFILE_FILE, "w", encoding="utf-8") as f:
            f.write(data.about_you.strip())
        
        # Read existing common.txt content
        existing_content = ""
        if os.path.exists(COMMON_PROMPTS_FILE):
            with open(COMMON_PROMPTS_FILE, "r", encoding="utf-8") as f:
                existing_content = f.read()
        
        # Check if user profile section already exists
        marker_start = "# --- USER PROFILE ---"
        marker_end = "# --- END USER PROFILE ---"
        
        if marker_start in existing_content:
            # Replace existing user profile section
            start_idx = existing_content.find(marker_start)
            end_idx = existing_content.find(marker_end)
            if end_idx != -1:
                end_idx += len(marker_end)
                new_content = (
                    existing_content[:start_idx].rstrip() + 
                    "\n\n" + marker_start + "\n" +
                    "About the user:\n" + data.about_you.strip() + 
                    "\n" + marker_end +
                    existing_content[end_idx:]
                )
            else:
                new_content = existing_content
        else:
            # Append new user profile section
            new_content = (
                existing_content.rstrip() + 
                "\n\n" + marker_start + "\n" +
                "About the user:\n" + data.about_you.strip() + 
                "\n" + marker_end + "\n"
            )
        
        # Write updated content
        with open(COMMON_PROMPTS_FILE, "w", encoding="utf-8") as f:
            f.write(new_content)
        
        return {"status": "ok", "message": "Profile updated successfully"}
    
    except Exception as e:
        print(f"Error updating profile: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update profile: {str(e)}")
