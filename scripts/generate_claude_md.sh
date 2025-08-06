#!/bin/bash
# ABOUTME: Generates CLAUDE.md from template with project configuration
# ABOUTME: Replaces placeholders with actual project values

set -e

# Load configuration
if [ ! -f "project.config.json" ]; then
    echo "Error: project.config.json not found."
    exit 1
fi

# Parse configuration
PROJECT_NAME=$(jq -r '.projectName' project.config.json)
BUNDLE_ID=$(jq -r '.bundleId' project.config.json)
PLATFORMS=$(jq -r '.platforms | join(", ")' project.config.json)
UI_FRAMEWORK=$(jq -r '.uiFramework' project.config.json)
IOS_VERSION=$(jq -r '.iosConfig.minVersion' project.config.json)
MACOS_VERSION=$(jq -r '.macosConfig.minVersion' project.config.json)

OUTPUT_DIR="output/${PROJECT_NAME}"
mkdir -p "$OUTPUT_DIR/.claude"

# Generate CLAUDE.md from template
sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{BUNDLE_ID}}/$BUNDLE_ID/g" \
    -e "s/{{PLATFORMS}}/$PLATFORMS/g" \
    -e "s/{{UI_FRAMEWORK}}/$UI_FRAMEWORK/g" \
    -e "s/{{IOS_VERSION}}/$IOS_VERSION/g" \
    -e "s/{{MACOS_VERSION}}/$MACOS_VERSION/g" \
    .claude/CLAUDE.md.template > "$OUTPUT_DIR/.claude/CLAUDE.md"

echo "Generated CLAUDE.md for $PROJECT_NAME"