#!/bin/bash
# ABOUTME: Generates customized Makefile based on project configuration
# ABOUTME: Includes only commands for selected platforms

set -e

# Load configuration
if [ ! -f "project.config.json" ]; then
    echo "Error: project.config.json not found."
    exit 1
fi

# Parse configuration
PROJECT_NAME=$(jq -r '.projectName' project.config.json)
PLATFORMS=$(jq -r '.platforms[]' project.config.json)

OUTPUT_DIR="output/${PROJECT_NAME}"

# Copy base Makefile and customize
sed -e "s/PROJECT_NAME ?= MyApp/PROJECT_NAME ?= $PROJECT_NAME/g" \
    -e "s/SCHEME ?= .*/SCHEME ?= $PROJECT_NAME/g" \
    Makefile > "$OUTPUT_DIR/Makefile"

echo "Generated Makefile for $PROJECT_NAME"