# ABOUTME: Makefile for iOS/macOS Claude Code development
# ABOUTME: Provides convenient commands for building, testing, and running apps

.PHONY: help
help: ## Show this help message
	@echo "iOS/macOS Claude Code Starter - Available Commands"
	@echo "=================================================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Configuration
PROJECT_NAME ?= MyApp
SCHEME ?= $(PROJECT_NAME)
SIMULATOR_NAME ?= iPhone 16
SIMULATOR_UUID ?= 
DEVICE_UUID ?= 
CONFIGURATION ?= Debug

# Paths
PROJECT_PATH = output/$(PROJECT_NAME)/$(PROJECT_NAME).xcodeproj
WORKSPACE_PATH = output/$(PROJECT_NAME)/$(PROJECT_NAME).xcworkspace

# Detect if workspace exists
USE_WORKSPACE := $(shell test -d $(WORKSPACE_PATH) && echo 1 || echo 0)

# iOS Build Commands
.PHONY: build-ios
build-ios: ## Build iOS app for simulator
	@echo "Building iOS app for simulator..."
ifeq ($(USE_WORKSPACE),1)
	@claude run mcp__xcode-build__build_sim_name_ws \
		--workspacePath "$(WORKSPACE_PATH)" \
		--scheme "$(SCHEME)" \
		--simulatorName "$(SIMULATOR_NAME)"
else
	@claude run mcp__xcode-build__build_sim_name_proj \
		--projectPath "$(PROJECT_PATH)" \
		--scheme "$(SCHEME)" \
		--simulatorName "$(SIMULATOR_NAME)"
endif

.PHONY: build-ios-device
build-ios-device: ## Build iOS app for physical device
	@echo "Building iOS app for device..."
	@claude run mcp__xcode-build__build_dev_proj \
		--projectPath "$(PROJECT_PATH)" \
		--scheme "$(SCHEME)"

.PHONY: run-ios
run-ios: ## Build and run on iOS simulator
	@echo "Running iOS app on simulator..."
ifeq ($(USE_WORKSPACE),1)
	@claude run mcp__xcode-build__build_run_sim_name_ws \
		--workspacePath "$(WORKSPACE_PATH)" \
		--scheme "$(SCHEME)" \
		--simulatorName "$(SIMULATOR_NAME)"
else
	@claude run mcp__xcode-build__build_run_sim_name_proj \
		--projectPath "$(PROJECT_PATH)" \
		--scheme "$(SCHEME)" \
		--simulatorName "$(SIMULATOR_NAME)"
endif

.PHONY: run-ios-device
run-ios-device: ## Build and run on connected iOS device
	@echo "Running iOS app on device..."
	@claude run mcp__xcode-build__list_devices
	@echo "Please set DEVICE_UUID and run again"

# macOS Build Commands
.PHONY: build-macos
build-macos: ## Build macOS app
	@echo "Building macOS app..."
	@claude run mcp__xcode-build__build_mac_proj \
		--projectPath "$(PROJECT_PATH)" \
		--scheme "$(SCHEME)Mac"

.PHONY: run-macos
run-macos: ## Build and run macOS app
	@echo "Running macOS app..."
	@claude run mcp__xcode-build__build_run_mac_proj \
		--projectPath "$(PROJECT_PATH)" \
		--scheme "$(SCHEME)Mac"

# Testing Commands
.PHONY: test
test: test-ios test-macos ## Run all tests

.PHONY: test-ios
test-ios: ## Run iOS tests
	@echo "Running iOS tests..."
ifeq ($(USE_WORKSPACE),1)
	@claude run mcp__xcode-build__test_sim_name_ws \
		--workspacePath "$(WORKSPACE_PATH)" \
		--scheme "$(SCHEME)" \
		--simulatorName "$(SIMULATOR_NAME)"
else
	@claude run mcp__xcode-build__test_sim_name_proj \
		--projectPath "$(PROJECT_PATH)" \
		--scheme "$(SCHEME)" \
		--simulatorName "$(SIMULATOR_NAME)"
endif

.PHONY: test-macos
test-macos: ## Run macOS tests
	@echo "Running macOS tests..."
	@claude run mcp__xcode-build__test_macos_proj \
		--projectPath "$(PROJECT_PATH)" \
		--scheme "$(SCHEME)Mac"

.PHONY: test-ui-ios
test-ui-ios: ## Run iOS UI tests
	@echo "Running iOS UI tests..."
	@claude run mcp__xcode-build__test_sim_name_proj \
		--projectPath "$(PROJECT_PATH)" \
		--scheme "$(SCHEME)UITests" \
		--simulatorName "$(SIMULATOR_NAME)"

# Simulator Management
.PHONY: list-sims
list-sims: ## List available iOS simulators
	@claude run mcp__xcode-build__list_sims

.PHONY: boot-sim
boot-sim: ## Boot iOS simulator
	@echo "Booting simulator..."
	@claude run mcp__xcode-build__open_sim

.PHONY: screenshot
screenshot: ## Take simulator screenshot
	@echo "Taking screenshot..."
	@claude run mcp__xcode-build__screenshot \
		--simulatorUuid "$(SIMULATOR_UUID)"

# Device Management
.PHONY: list-devices
list-devices: ## List connected physical devices
	@claude run mcp__xcode-build__list_devices

.PHONY: install-device
install-device: ## Install app on connected device
	@echo "Installing on device..."
	@claude run mcp__xcode-build__install_app_device \
		--deviceId "$(DEVICE_UUID)" \
		--appPath "DerivedData/Build/Products/$(CONFIGURATION)-iphoneos/$(PROJECT_NAME).app"

# Clean Commands
.PHONY: clean
clean: ## Clean all build artifacts
	@echo "Cleaning build artifacts..."
	@claude run mcp__xcode-build__clean_proj \
		--projectPath "$(PROJECT_PATH)"

.PHONY: clean-derived-data
clean-derived-data: ## Remove DerivedData folder
	@echo "Removing DerivedData..."
	@rm -rf ~/Library/Developer/Xcode/DerivedData
	@rm -rf DerivedData

.PHONY: reset-simulators
reset-simulators: ## Reset all simulators
	@echo "Resetting simulators..."
	@xcrun simctl erase all

# Project Setup
.PHONY: setup
setup: ## Run interactive project setup
	@./setup.sh

.PHONY: generate-project
generate-project: ## Generate project from configuration
	@echo "Generating project from configuration..."
	@./scripts/generate_project.sh

.PHONY: generate-project-to
generate-project-to: ## Generate project to specific directory (use OUTPUT_DIR=path)
	@echo "Generating project to $(OUTPUT_DIR)..."
	@./scripts/generate_project.sh "$(OUTPUT_DIR)"

# Template Tests
.PHONY: test-generator
test-generator: ## Test the project generator
	@echo "Running generator tests..."
	@./tests/test_generator.sh

.PHONY: test-template
test-template: test-generator ## Alias for test-generator

# Utility Commands
.PHONY: schemes
schemes: ## List available schemes
	@claude run mcp__xcode-build__list_schems_proj \
		--projectPath "$(PROJECT_PATH)"

.PHONY: build-settings
build-settings: ## Show build settings
	@claude run mcp__xcode-build__show_build_set_proj \
		--projectPath "$(PROJECT_PATH)" \
		--scheme "$(SCHEME)"

.PHONY: diagnostic
diagnostic: ## Run MCP diagnostic
	@claude run mcp__xcode-build__diagnostic

# Swift Package Manager
.PHONY: update-packages
update-packages: ## Update Swift packages
	@echo "Updating packages..."
	@swift package update

.PHONY: resolve-packages
resolve-packages: ## Resolve Swift package dependencies
	@echo "Resolving packages..."
	@swift package resolve

# CI/CD Commands
.PHONY: ci-test
ci-test: ## Run tests for CI
	@echo "Running CI tests..."
	@make test

.PHONY: archive
archive: ## Create release archive
	@echo "Creating archive..."
	@xcodebuild archive \
		-project "$(PROJECT_PATH)" \
		-scheme "$(SCHEME)" \
		-archivePath "build/$(PROJECT_NAME).xcarchive"

# Development Helpers
.PHONY: check-deps
check-deps: ## Check required dependencies
	@echo "Checking dependencies..."
	@which claude >/dev/null 2>&1 || (echo "❌ Claude CLI not found. Install from https://claude.ai/code" && exit 1)
	@which xcodebuild >/dev/null 2>&1 || (echo "❌ Xcode not found. Install from App Store" && exit 1)
	@which jq >/dev/null 2>&1 || (echo "⚠️  jq not found. Install with: brew install jq")
	@echo "✅ All required dependencies found"

.PHONY: format
format: ## Format Swift code
	@echo "Formatting code..."
	@if command -v swiftformat >/dev/null 2>&1; then \
		swiftformat . ; \
	else \
		echo "SwiftFormat not installed. Install with: brew install swiftformat" ; \
	fi

.PHONY: lint
lint: ## Run SwiftLint
	@echo "Linting code..."
	@if command -v swiftlint >/dev/null 2>&1; then \
		swiftlint ; \
	else \
		echo "SwiftLint not installed. Install with: brew install swiftlint" ; \
	fi

# Quick Commands
.PHONY: ios
ios: run-ios ## Alias for run-ios

.PHONY: mac
mac: run-macos ## Alias for run-macos

.PHONY: macos
macos: run-macos ## Alias for run-macos

# Open in Xcode (fallback option)
.PHONY: open-xcode
open-xcode: ## Open project in Xcode
ifeq ($(USE_WORKSPACE),1)
	@open "$(WORKSPACE_PATH)"
else
	@open "$(PROJECT_PATH)"
endif

# Default target
.DEFAULT_GOAL := help