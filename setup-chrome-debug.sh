#!/bin/bash

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Clear screen and show header
clear
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                Chrome Debug Profile Setup                      ║${NC}"
echo -e "${CYAN}║              Chrome Debugging Configuration                    ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Source Chrome directory
SOURCE_CHROME="$HOME/Library/Application Support/Google/Chrome"

# Check if Chrome directory exists
if [ ! -d "$SOURCE_CHROME" ]; then
    echo -e "${RED}❌ Chrome directory not found at: $SOURCE_CHROME${NC}"
    echo -e "${RED}   Please make sure Chrome is installed.${NC}"
    exit 1
fi

# Function to list available Chrome profiles
list_profiles() {
    echo -e "${BLUE}🔍 Scanning for Chrome profiles...${NC}"
    echo ""
    
    local profiles=()
    local counter=1
    
    # Add Default profile if it exists
    if [ -d "$SOURCE_CHROME/Default" ]; then
        profiles+=("Default")
        echo -e "${GREEN}[$counter]${NC} Default Profile"
        ((counter++))
    fi
    
    # Add other profiles
    for profile_dir in "$SOURCE_CHROME"/Profile*; do
        if [ -d "$profile_dir" ]; then
            profile_name=$(basename "$profile_dir")
            profiles+=("$profile_name")
            echo -e "${GREEN}[$counter]${NC} $profile_name"
            ((counter++))
        fi
    done
    
    if [ ${#profiles[@]} -eq 0 ]; then
        echo -e "${RED}❌ No Chrome profiles found!${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${YELLOW}📝 Select source profile [1-$((counter-1))]:${NC} "
    read -r selection
    
    # Validate selection
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -ge "$counter" ]; then
        echo -e "${RED}❌ Invalid selection!${NC}"
        exit 1
    fi
    
    selected_profile=${profiles[$((selection-1))]}
    echo -e "${GREEN}✅ Selected: $selected_profile${NC}"
    echo ""
}

# Function to get debug profile name
get_debug_profile_name() {
    echo -e "${BLUE}📁 Debug Profile Configuration${NC}"
    echo -e "${YELLOW}   Enter name for your debug profile (default: chrome-debug-profile):${NC} "
    read -r debug_name
    
    if [ -z "$debug_name" ]; then
        debug_name="chrome-debug-profile"
    fi
    
    # Sanitize the name (remove special characters)
    debug_name=$(echo "$debug_name" | sed 's/[^a-zA-Z0-9-]/-/g')
    
    echo -e "${GREEN}✅ Debug profile name: $debug_name${NC}"
    echo ""
}

# Function to ask about password copying
ask_about_passwords() {
    echo -e "${BLUE}🔐 Password Settings${NC}"
    echo -e "${YELLOW}   Do you want to copy saved passwords to the debug profile? (y/N):${NC} "
    read -r copy_passwords
    
    case "$copy_passwords" in
        [Yy]|[Yy][Ee][Ss])
            copy_passwords=true
            echo -e "${GREEN}✅ Passwords will be copied${NC}"
            ;;
        *)
            copy_passwords=false
            echo -e "${YELLOW}⚠️  Passwords will NOT be copied${NC}"
            ;;
    esac
    echo ""
}

# Function to copy Chrome data
copy_chrome_data() {
    local source_profile="$SOURCE_CHROME/$selected_profile"
    local debug_profile="$PWD/.vscode/$debug_name"
    
    echo -e "${BLUE}🚀 Starting Chrome data copy...${NC}"
    echo ""
    
    # Close Chrome first
    echo -e "${YELLOW}🔄 Closing Chrome processes...${NC}"
    pkill -f "Google Chrome" 2>/dev/null || true
    sleep 2
    
    # Remove existing debug profile
    if [ -d "$debug_profile" ]; then
        echo -e "${YELLOW}🗑️  Removing existing debug profile...${NC}"
        rm -rf "$debug_profile"
    fi
    
    # Create debug profile directory
    mkdir -p "$debug_profile/Default"
    
    echo -e "${CYAN}📋 Copying Chrome data from: $selected_profile${NC}"
    echo -e "${CYAN}📋 To debug profile: $debug_name${NC}"
    echo ""
    
    local copied_items=0
    local total_items=0
    
    # Copy extensions
    if [ -d "$source_profile/Extensions" ]; then
        echo -e "${YELLOW}📦 Copying Extensions...${NC}"
        cp -R "$source_profile/Extensions" "$debug_profile/Default/"
        extension_count=$(ls "$source_profile/Extensions" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${GREEN}✅ Copied $extension_count extensions${NC}"
        ((copied_items++))
    fi
    ((total_items++))
    
    # Copy preferences
    if [ -f "$source_profile/Preferences" ]; then
        echo -e "${YELLOW}⚙️  Copying Preferences...${NC}"
        cp "$source_profile/Preferences" "$debug_profile/Default/"
        echo -e "${GREEN}✅ Preferences copied${NC}"
        ((copied_items++))
    fi
    ((total_items++))
    
    # Copy secure preferences
    if [ -f "$source_profile/Secure Preferences" ]; then
        echo -e "${YELLOW}🔒 Copying Secure Preferences...${NC}"
        cp "$source_profile/Secure Preferences" "$debug_profile/Default/"
        echo -e "${GREEN}✅ Secure Preferences copied${NC}"
        ((copied_items++))
    fi
    ((total_items++))
    
    # Copy passwords (optional)
    if [ "$copy_passwords" = true ]; then
        if [ -f "$source_profile/Login Data" ]; then
            echo -e "${YELLOW}🔐 Copying Login Data (passwords)...${NC}"
            cp "$source_profile/Login Data" "$debug_profile/Default/"
            echo -e "${GREEN}✅ Login Data copied${NC}"
            ((copied_items++))
        fi
    else
        echo -e "${YELLOW}⏭️  Skipping Login Data (passwords)${NC}"
    fi
    ((total_items++))
    
    # Copy other important data
    local items=(
        "Extension Cookies:Extension Cookies"
        "Cookies:Cookies"
        "Bookmarks:Bookmarks"
        "Web Data:Web Data"
    )
    
    for item in "${items[@]}"; do
        IFS=":" read -r display_name file_name <<< "$item"
        if [ -f "$source_profile/$file_name" ]; then
            echo -e "${YELLOW}📄 Copying $display_name...${NC}"
            cp "$source_profile/$file_name" "$debug_profile/Default/"
            echo -e "${GREEN}✅ $display_name copied${NC}"
            ((copied_items++))
        fi
        ((total_items++))
    done
    
    # Copy directories
    local directories=(
        "Local Storage:Local Storage"
        "IndexedDB:IndexedDB (extension storage)"
        "Extension Rules:Extension Rules"
        "Local Extension Settings:Local Extension Settings"
        "Sync Extension Settings:Sync Extension Settings"
    )
    
    for item in "${directories[@]}"; do
        IFS=":" read -r dir_name display_name <<< "$item"
        if [ -d "$source_profile/$dir_name" ]; then
            echo -e "${YELLOW}📁 Copying $display_name...${NC}"
            cp -R "$source_profile/$dir_name" "$debug_profile/Default/"
            echo -e "${GREEN}✅ $display_name copied${NC}"
            ((copied_items++))
        fi
        ((total_items++))
    done
    
    echo ""
    echo -e "${GREEN}🎉 Copy completed! ($copied_items/$total_items items copied)${NC}"
    echo ""
}

# Function to update VS Code launch configuration
update_vscode_config() {
    local launch_file=".vscode/launch.json"
    
    echo -e "${BLUE}⚙️  Updating VS Code configuration...${NC}"
    
    # Create .vscode directory if it doesn't exist
    mkdir -p .vscode
    
    # Create or update launch.json
    cat > "$launch_file" << EOF
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "chrome",
            "request": "launch",
            "name": "Debug Chrome - $debug_name",
            "url": "http://localhost:3003",
            "webRoot": "\${workspaceFolder}/src",
            "userDataDir": "\${workspaceFolder}/.vscode/$debug_name"
        }
    ]
}
EOF
    
    echo -e "${GREEN}✅ VS Code launch.json updated${NC}"
    echo ""
}

# Function to show summary
show_summary() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                            SUMMARY                             ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}✅ Source Profile:${NC} $selected_profile"
    echo -e "${GREEN}✅ Debug Profile:${NC} $debug_name"
    echo -e "${GREEN}✅ Passwords Copied:${NC} $([ "$copy_passwords" = true ] && echo "Yes" || echo "No")"
    echo -e "${GREEN}✅ VS Code Config:${NC} Updated"
    echo ""
    echo -e "${BLUE}🚀 Next Steps:${NC}"
    echo -e "   1. Press ${YELLOW}F5${NC} in VS Code"
    echo -e "   2. Select ${YELLOW}'Debug Chrome - $debug_name'${NC}"
    echo -e "   3. Start debugging!"
    echo ""
    echo -e "${CYAN}💡 Tip: Run this script again anytime to update your debug profile${NC}"
    echo ""
}

# Main execution
echo -e "${BLUE}Starting Chrome Debug Profile Setup...${NC}"
echo ""

# Step 1: Get debug profile name
get_debug_profile_name

# Step 2: List and select profile
list_profiles

# Step 3: Ask about passwords
ask_about_passwords

# Step 4: Copy Chrome data
copy_chrome_data

# Step 5: Update VS Code configuration
update_vscode_config

# Step 6: Show summary
show_summary

echo -e "${GREEN}🎉 Setup completed successfully!${NC}"