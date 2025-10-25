#!/bin/bash

# Nerd Fonts Installer - Auto-detects latest version

FONTS_DIR="$HOME/.local/share/fonts"
TEMP_DIR="/tmp/nerd-fonts-install"

# Function to get the latest release version from GitHub
get_latest_version() {
    echo "Checking for latest Nerd Fonts version..." >&2
    
    # Try to get latest version from GitHub API
    local latest_version=$(wget -qO- https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest 2>/dev/null | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    # If that fails, try alternative method
    if [ -z "$latest_version" ]; then
        latest_version=$(wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/latest 2>/dev/null | grep -oP 'tag/\K[^"]+' | head -1)
    fi
    
    # If still failed, use fallback version
    if [ -z "$latest_version" ]; then
        latest_version="v3.4.0"
        echo "Could not fetch latest version from GitHub, using fallback: $latest_version" >&2
    else
        echo "Latest version: $latest_version" >&2
    fi
    
    echo "$latest_version"
}

# Function to check if a font is installed
is_font_installed() {
    local font_name="$1"
    
    if fc-list | grep -qi "$font_name"; then
        return 0
    else
        return 1
    fi
}

# Function to install a single Nerd Font
install_nerd_font() {
    local font_name="$1"
    local version="$2"
    local download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${font_name}.zip"
    
    echo "Processing font: $font_name"
    echo "Downloading $font_name..."
    
    mkdir -p "$TEMP_DIR"
    
    if ! wget -q --show-progress "$download_url" -O "$TEMP_DIR/${font_name}.zip"; then
        echo "Failed to download $font_name"
        echo "URL: $download_url"
        echo "This may be due to network restrictions blocking release-assets.githubusercontent.com"
        return 1
    fi
    
    echo "Installing $font_name..."
    
    mkdir -p "$FONTS_DIR/$font_name"
    
    if ! unzip -q -o "$TEMP_DIR/${font_name}.zip" -d "$FONTS_DIR/$font_name"; then
        echo "Failed to extract $font_name"
        rm -f "$TEMP_DIR/${font_name}.zip"
        return 1
    fi
    
    rm -f "$TEMP_DIR/${font_name}.zip"
    
    echo "$font_name installed successfully"
    return 0
}

# Function to update font cache
update_font_cache() {
    echo "Updating font cache..."
    fc-cache -fv > /dev/null 2>&1
    echo "Font cache updated"
}

# Main installation function
main() {
    echo "Starting Nerd Fonts installation..."
    
    # Get latest version
    NERD_FONTS_VERSION=$(get_latest_version)
    echo ""
    
    # List of fonts to install
    # Add or remove fonts from this array as needed
    local fonts=(
        "CascadiaCode"
        "CascadiaMono"
        "FiraCode"
        "FiraMono"
        "JetBrainsMono"
        "ZedMono"
        "RobotoMono"
        "SourceCodePro"
    )
    
    local installed_count=0
    local skipped_count=0
    
    # Install each font
    for font in "${fonts[@]}"; do
        if is_font_installed "$font"; then
            echo "Processing font: $font"
            echo "$font is already installed. Skipping..."
            ((skipped_count++))
        else
            if install_nerd_font "$font" "$NERD_FONTS_VERSION"; then
                ((installed_count++))
            fi
        fi
        echo ""
    done
    
    # Update font cache if any fonts were installed
    if [ $installed_count -gt 0 ]; then
        update_font_cache
    fi
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    # Print summary
    echo ""
    echo "Installation Summary:"
    echo "  Version: $NERD_FONTS_VERSION"
    echo "  Installed: $installed_count"
    echo "  Skipped: $skipped_count"
    echo ""
    
    if [ $installed_count -gt 0 ]; then
        echo "Done. You may need to restart your terminal or applications to see the new fonts."
    else
        echo "Done."
    fi
}

# Run the script
main
