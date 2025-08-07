#!/bin/bash
# ABOUTME: Generates Xcode project from templates using configuration
# ABOUTME: Uses MCP tools to scaffold iOS/macOS projects

set -e

# Load configuration
if [ ! -f "project.config.json" ]; then
    echo "Error: project.config.json not found. Run setup.sh first."
    exit 1
fi

# Parse configuration using jq
PROJECT_NAME=$(jq -r '.projectName' project.config.json)
BUNDLE_ID=$(jq -r '.bundleId' project.config.json)
DISPLAY_NAME=$(jq -r '.displayName' project.config.json)
PLATFORMS=$(jq -r '.platforms[]' project.config.json)
UI_FRAMEWORK=$(jq -r '.uiFramework' project.config.json)
IOS_VERSION=$(jq -r '.iosConfig.minVersion' project.config.json)
IOS_DEVICE_FAMILY=$(jq -r '.iosConfig.deviceFamily' project.config.json)
MACOS_VERSION=$(jq -r '.macosConfig.minVersion' project.config.json)

# Accept optional output base directory, default to "output"
OUTPUT_BASE_DIR="${1:-output}"
OUTPUT_DIR="${OUTPUT_BASE_DIR}/${PROJECT_NAME}"

echo "Generating project: $PROJECT_NAME"
echo "Output directory: $OUTPUT_DIR"

# Create output directory
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Generate iOS project if selected
if echo "$PLATFORMS" | grep -q "ios"; then
    echo "Generating iOS project..."
    
    # Determine device families
    case "$IOS_DEVICE_FAMILY" in
        "iphone")
            DEVICE_FAMILIES='["iphone"]'
            ;;
        "ipad")
            DEVICE_FAMILIES='["ipad"]'
            ;;
        *)
            DEVICE_FAMILIES='["universal"]'
            ;;
    esac
    
    # Note: When running from Claude Code, it will execute the MCP command directly
    echo "Note: Claude Code should execute the following MCP command:"
    echo "mcp__xcode-build__scaffold_ios_project with parameters:"
    echo "  projectName: $PROJECT_NAME"
    echo "  outputPath: $OUTPUT_DIR"
    echo "  bundleIdentifier: $BUNDLE_ID"
    echo "  displayName: $DISPLAY_NAME"
    echo "  deploymentTarget: $IOS_VERSION"
    echo "  targetedDeviceFamily: $DEVICE_FAMILIES"
fi

# Generate macOS project if selected
if echo "$PLATFORMS" | grep -q "macos"; then
    echo "Generating macOS project..."
    
    # Note: When running from Claude Code, it will execute the MCP command directly
    echo "Note: Claude Code should execute the following MCP command:"
    echo "mcp__xcode-build__scaffold_macos_project with parameters:"
    echo "  projectName: ${PROJECT_NAME}Mac"
    echo "  outputPath: $OUTPUT_DIR"
    echo "  bundleIdentifier: ${BUNDLE_ID}.mac"
    echo "  displayName: $DISPLAY_NAME"
    echo "  deploymentTarget: $MACOS_VERSION"
fi

# Copy and process templates
echo "Processing templates..."

# Process Swift files
for platform in $PLATFORMS; do
    if [ "$platform" = "ios" ]; then
        TARGET_DIR="$OUTPUT_DIR/$PROJECT_NAME"
        mkdir -p "$TARGET_DIR/Sources"
        
        # Process iOS templates
        for template in templates/ios/*.swift.template; do
            if [ -f "$template" ]; then
                filename=$(basename "$template" .template)
                sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
                    -e "s/{{BUNDLE_ID}}/$BUNDLE_ID/g" \
                    -e "s/{{DEVICE_TYPE}}/iOS/g" \
                    "$template" > "$TARGET_DIR/Sources/$filename"
            fi
        done
        
        # Process iOS tests
        mkdir -p "$TARGET_DIR/Tests"
        for template in templates/ios/Tests/*.swift.template; do
            if [ -f "$template" ]; then
                filename=$(basename "$template" .template)
                sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
                    "$template" > "$TARGET_DIR/Tests/$filename"
            fi
        done
    fi
    
    if [ "$platform" = "macos" ]; then
        TARGET_DIR="$OUTPUT_DIR/${PROJECT_NAME}Mac"
        mkdir -p "$TARGET_DIR/Sources"
        
        # Process macOS templates
        for template in templates/macos/*.swift.template; do
            if [ -f "$template" ]; then
                filename=$(basename "$template" .template)
                sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
                    -e "s/{{BUNDLE_ID}}/$BUNDLE_ID/g" \
                    "$template" > "$TARGET_DIR/Sources/$filename"
            fi
        done
        
        # Process macOS tests
        mkdir -p "$TARGET_DIR/Tests"
        for template in templates/macos/Tests/*.swift.template; do
            if [ -f "$template" ]; then
                filename=$(basename "$template" .template)
                sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
                    "$template" > "$TARGET_DIR/Tests/$filename"
            fi
        done
    fi
done

# Generate CLAUDE.md
echo "Generating CLAUDE.md..."
./scripts/generate_claude_md.sh "$OUTPUT_BASE_DIR"

# Generate GitHub Actions workflow if enabled
if [ "$(jq -r '.includeCI' project.config.json)" = "true" ]; then
    echo "Generating GitHub Actions workflow..."
    ./scripts/generate_github_actions.sh "$OUTPUT_BASE_DIR"
fi

# Copy Makefile
echo "Copying Makefile..."
sed -e "s/PROJECT_NAME ?= MyApp/PROJECT_NAME ?= $PROJECT_NAME/g" \
    Makefile > "$OUTPUT_DIR/Makefile"

# Copy .gitignore from template
echo "Copying .gitignore..."
if [ -f "templates/.gitignore.template" ]; then
    sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
        templates/.gitignore.template > "$OUTPUT_DIR/.gitignore"
else
    # Fallback to root .gitignore if template doesn't exist
    cp .gitignore "$OUTPUT_DIR/"
fi

# Copy all .claude files
echo "Copying .claude configuration files..."
if [ -d ".claude" ]; then
    mkdir -p "$OUTPUT_DIR/.claude"
    # Copy settings.local.json if it exists
    if [ -f ".claude/settings.local.json" ]; then
        cp ".claude/settings.local.json" "$OUTPUT_DIR/.claude/"
    fi
fi

# Create README for the generated project
cat > "$OUTPUT_DIR/README.md" << EOF
# $PROJECT_NAME

Generated from iOS/macOS Claude Code Starter Template

## Quick Start

\`\`\`bash
# Show available commands
make help

# Run on iOS simulator
make ios

# Run on macOS
make mac

# Run all tests
make test
\`\`\`

## Project Information

- **Bundle ID**: $BUNDLE_ID
- **Platforms**: $(echo $PLATFORMS | tr '\n' ', ')
- **UI Framework**: $UI_FRAMEWORK
- **iOS Minimum Version**: $IOS_VERSION
- **macOS Minimum Version**: $MACOS_VERSION

## Development

This project is configured for CLI-driven development using Claude Code.
See CLAUDE.md for Claude-specific instructions and workflows.

## Testing

\`\`\`bash
make test-ios    # Run iOS tests
make test-macos  # Run macOS tests
make test        # Run all tests
\`\`\`

## Building

\`\`\`bash
make build-ios    # Build for iOS simulator
make build-macos  # Build macOS app
\`\`\`
EOF

echo ""
echo "✅ Project generated successfully!"
echo ""
echo "Next steps:"
echo "  cd $OUTPUT_DIR"
echo "  make help      # Show available commands"
echo "  make ios       # Run on iOS simulator"
echo "  make mac       # Run on macOS"
echo ""