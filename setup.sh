#!/bin/bash
# ABOUTME: Interactive setup script for iOS/macOS Claude Code starter
# ABOUTME: Configures project based on user preferences and generates appropriate structure

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DEFAULT_PROJECT_NAME="MyApp"
DEFAULT_BUNDLE_ID="com.example.myapp"
DEFAULT_IOS_VERSION="18.4"
DEFAULT_MACOS_VERSION="15.4"

# Function to print colored output
print_color() {
    printf "${2}${1}${NC}\n"
}

# Function to prompt user with default value
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local response
    
    read -p "$prompt [$default]: " response
    echo "${response:-$default}"
}

# Function to prompt yes/no
prompt_yes_no() {
    local prompt="$1"
    local default="${2:-n}"
    local response
    
    if [ "$default" = "y" ]; then
        read -p "$prompt [Y/n]: " response
        response="${response:-y}"
    else
        read -p "$prompt [y/N]: " response
        response="${response:-n}"
    fi
    
    [[ "$response" =~ ^[Yy]$ ]]
}

# Function to select from options
select_option() {
    local prompt="$1"
    shift
    local options=("$@")
    
    echo "$prompt"
    for i in "${!options[@]}"; do
        echo "  $((i+1))) ${options[$i]}"
    done
    
    local choice
    while true; do
        read -p "Enter choice [1-${#options[@]}]: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "${options[$((choice-1))]}"
            return
        else
            print_color "Invalid choice. Please try again." "$RED"
        fi
    done
}

# Welcome message
clear
print_color "========================================" "$BLUE"
print_color "iOS/macOS Claude Code Starter Setup" "$BLUE"
print_color "========================================" "$BLUE"
echo ""
print_color "This wizard will help you configure your iOS/macOS project" "$GREEN"
print_color "for CLI-driven development with Claude Code." "$GREEN"
echo ""

# Project configuration
PROJECT_NAME=$(prompt_with_default "Project name" "$DEFAULT_PROJECT_NAME")
BUNDLE_ID=$(prompt_with_default "Bundle identifier" "$DEFAULT_BUNDLE_ID")
DISPLAY_NAME=$(prompt_with_default "Display name" "$PROJECT_NAME")

# Platform selection
echo ""
print_color "Select target platforms (you can choose multiple):" "$YELLOW"
PLATFORMS=()

if prompt_yes_no "Include iOS" "y"; then
    PLATFORMS+=("ios")
    
    # iOS specific configuration
    echo ""
    print_color "iOS Configuration:" "$BLUE"
    IOS_VERSION=$(select_option "Select minimum iOS version:" "16.0" "17.0" "18.0" "18.4")
    
    IOS_DEVICES=$(select_option "Select device family:" "iPhone only" "iPad only" "Universal (iPhone + iPad)")
    case "$IOS_DEVICES" in
        "iPhone only")
            IOS_DEVICE_FAMILY="iphone"
            ;;
        "iPad only")
            IOS_DEVICE_FAMILY="ipad"
            ;;
        *)
            IOS_DEVICE_FAMILY="universal"
            ;;
    esac
fi

if prompt_yes_no "Include macOS" "y"; then
    PLATFORMS+=("macos")
    
    # macOS specific configuration
    echo ""
    print_color "macOS Configuration:" "$BLUE"
    MACOS_VERSION=$(select_option "Select minimum macOS version:" "13.0" "14.0" "15.0" "15.4")
fi

if prompt_yes_no "Include watchOS" "n"; then
    PLATFORMS+=("watchos")
    WATCHOS_VERSION="10.0"
fi

if prompt_yes_no "Include tvOS" "n"; then
    PLATFORMS+=("tvos")
    TVOS_VERSION="17.0"
fi

if prompt_yes_no "Include visionOS" "n"; then
    PLATFORMS+=("visionos")
    VISIONOS_VERSION="2.0"
fi

# UI Framework selection
echo ""
UI_FRAMEWORK=$(select_option "Select UI framework:" "SwiftUI (recommended)" "UIKit" "Both")
case "$UI_FRAMEWORK" in
    "SwiftUI (recommended)")
        UI_FRAMEWORK="swiftui"
        ;;
    "UIKit")
        UI_FRAMEWORK="uikit"
        ;;
    *)
        UI_FRAMEWORK="both"
        ;;
esac

# Testing preference
echo ""
INCLUDE_TESTS=true
if ! prompt_yes_no "Include comprehensive test suite" "y"; then
    INCLUDE_TESTS=false
fi

# CI/CD preference
echo ""
INCLUDE_CI=true
if ! prompt_yes_no "Include GitHub Actions CI/CD" "y"; then
    INCLUDE_CI=false
fi

# Create configuration file
print_color "\nGenerating configuration..." "$YELLOW"

cat > project.config.json << EOF
{
  "projectName": "$PROJECT_NAME",
  "bundleId": "$BUNDLE_ID",
  "displayName": "$DISPLAY_NAME",
  "platforms": $(printf '%s\n' "${PLATFORMS[@]}" | jq -R . | jq -s .),
  "uiFramework": "$UI_FRAMEWORK",
  "includeTests": $INCLUDE_TESTS,
  "includeCI": $INCLUDE_CI,
  "iosConfig": {
    "minVersion": "${IOS_VERSION:-18.4}",
    "deviceFamily": "${IOS_DEVICE_FAMILY:-universal}"
  },
  "macosConfig": {
    "minVersion": "${MACOS_VERSION:-15.4}"
  },
  "watchosConfig": {
    "minVersion": "${WATCHOS_VERSION:-10.0}"
  },
  "tvosConfig": {
    "minVersion": "${TVOS_VERSION:-17.0}"
  },
  "visionosConfig": {
    "minVersion": "${VISIONOS_VERSION:-2.0}"
  }
}
EOF

# Generate project structure
print_color "\nGenerating project structure..." "$YELLOW"

# Create output directory
OUTPUT_DIR="output/${PROJECT_NAME}"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Generate projects based on platforms
for platform in "${PLATFORMS[@]}"; do
    print_color "Generating $platform project..." "$GREEN"
    
    case "$platform" in
        "ios")
            # Use the scaffold tool to create iOS project
            echo "Creating iOS project with Claude Code MCP tools..."
            # This will be called from the generate script
            ;;
        "macos")
            # Use the scaffold tool to create macOS project
            echo "Creating macOS project with Claude Code MCP tools..."
            # This will be called from the generate script
            ;;
        *)
            echo "Platform $platform will be configured..."
            ;;
    esac
done

# Generate customized CLAUDE.md
print_color "\nGenerating CLAUDE.md..." "$YELLOW"
./scripts/generate_claude_md.sh

# Generate Makefile
print_color "Generating Makefile..." "$YELLOW"
./scripts/generate_makefile.sh

# Generate GitHub Actions if requested
if [ "$INCLUDE_CI" = true ]; then
    print_color "Generating GitHub Actions workflow..." "$YELLOW"
    ./scripts/generate_github_actions.sh
fi

# Final message
echo ""
print_color "========================================" "$GREEN"
print_color "Setup Complete!" "$GREEN"
print_color "========================================" "$GREEN"
echo ""
print_color "Your project has been configured and generated in: $OUTPUT_DIR" "$BLUE"
echo ""
print_color "Quick start commands:" "$YELLOW"
echo "  cd $OUTPUT_DIR"
echo "  make help          # Show all available commands"
echo "  make build-ios     # Build for iOS simulator"
echo "  make build-macos   # Build for macOS"
echo "  make test          # Run all tests"
echo "  make run-ios       # Run on iOS simulator"
echo "  make run-macos     # Run macOS app"
echo ""
print_color "For Claude Code:" "$YELLOW"
echo "  Your project is ready for CLI-driven development!"
echo "  Use 'claude' in the project directory to start coding."
echo ""