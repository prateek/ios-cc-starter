#!/bin/bash
# ABOUTME: Generates GitHub Actions workflow from template
# ABOUTME: Customizes based on selected platforms and testing preferences

set -e

# Load configuration
if [ ! -f "project.config.json" ]; then
    echo "Error: project.config.json not found."
    exit 1
fi

# Parse configuration
PROJECT_NAME=$(jq -r '.projectName' project.config.json)
PLATFORMS=$(jq -r '.platforms[]' project.config.json)
INCLUDE_TESTS=$(jq -r '.includeTests' project.config.json)

OUTPUT_DIR="output/${PROJECT_NAME}"
mkdir -p "$OUTPUT_DIR/.github/workflows"

# Generate workflow from template
sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    .github/workflows/test.yml.template > "$OUTPUT_DIR/.github/workflows/test.yml"

echo "Generated GitHub Actions workflow for $PROJECT_NAME"