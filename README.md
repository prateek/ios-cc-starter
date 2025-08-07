# iOS/macOS Claude Code Starter

[![Template CI](https://github.com/prateek/ios-cc-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/prateek/ios-cc-starter/actions/workflows/ci.yml)

CLI-driven iOS/macOS development template for Claude Code - no Xcode UI required!

## Quick Start

### Interactive Setup
```bash
# Clone and setup
git clone https://github.com/prateek/ios-cc-starter
cd ios-cc-starter
./setup.sh

# Navigate to your project
cd output/YourProjectName
```

### Non-Interactive Setup
```bash
# Use a config file for automated setup
./setup.sh --config sample.config.json

# Or create your own config (see sample.config.json)
./setup.sh --config my-project.config.json
```

### Custom Output Directory
```bash
# Generate to a specific directory
./scripts/generate_project.sh /path/to/my/projects

# Or use the Makefile
make generate-project-to OUTPUT_DIR=/path/to/my/projects
```

### Running Your App
```bash
cd output/YourProjectName

# Check dependencies first
make check-deps

# Run your app
make ios   # iOS simulator
make mac   # macOS
make test  # Run all tests
```

## Features

✅ Interactive project configuration wizard  
✅ Hello World apps with SwiftUI and comprehensive tests  
✅ Full MCP xcode-build integration for CLI-only development  
✅ Multi-platform: iOS, macOS, watchOS, tvOS, visionOS  
✅ GitHub Actions CI/CD ready for generated projects  
✅ Complete `.claude` configuration included (CLAUDE.md + settings.local.json)  
✅ Simple Makefile commands for everything  
✅ Tested generator with CI/CD pipeline  
✅ Custom output directory support

## What You Get

### Generated Project Structure
```
YourProject/
├── .claude/
│   ├── CLAUDE.md           # Project-specific Claude instructions
│   └── settings.local.json # MCP server configuration
├── .github/
│   └── workflows/
│       └── test.yml        # CI/CD pipeline for your project
├── YourProject/            # iOS app target
│   ├── Sources/            # Swift source files
│   └── Tests/              # Unit and UI tests
├── YourProjectMac/         # macOS app target (if selected)
├── Makefile                # All build/test/run commands
├── README.md               # Project documentation
└── .gitignore              # Properly configured git ignores
```

### Generated Apps
- **iOS**: SwiftUI Hello World with interactive counter, tests, and UI automation
- **macOS**: Native app with menu bar, preferences, and keyboard shortcuts
- **Tests**: Unit, UI, integration, and performance tests included
- **CI/CD**: GitHub Actions workflow for automated testing

### Key Commands
```bash
make help          # Show all commands
make check-deps    # Verify dependencies
make ios          # Run iOS simulator
make mac          # Run macOS app
make test         # Run all tests
make list-sims    # List simulators
make clean        # Clean build
make open-xcode    # Open in Xcode (if needed)
```

## Building Your App

### iOS Build Instructions

```bash
# Build for iOS Simulator
make build-ios

# Build for physical iOS device
make build-ios-device

# Build and run on simulator
make ios
# or
make run-ios

# Specify a specific simulator
make run-ios SIMULATOR_NAME="iPhone 15 Pro"
```

### macOS Build Instructions

```bash
# Build macOS app
make build-macos

# Build and run macOS app
make mac
# or
make run-macos
```

### Build Configurations

```bash
# Debug build (default)
make build-ios CONFIGURATION=Debug

# Release build
make build-ios CONFIGURATION=Release

# Verbose output (show all xcodebuild output)
make verbose build-ios

# Quiet mode (minimal output, logs to file)
make quiet build-ios
```

## Running Your App

### On iOS Simulator

```bash
# Quick run with default simulator
make ios

# Boot simulator first, then run
make boot-sim
make run-ios

# List available simulators
make list-sims

# Run on specific simulator
make run-ios SIMULATOR_NAME="iPad Pro (12.9-inch)"
```

### On Physical iOS Device

```bash
# List connected devices
make list-devices

# Build and install on device
make build-ios-device
make install-device DEVICE_UUID=<your-device-id>

# Launch on device
make launch-device DEVICE_UUID=<your-device-id>
```

### On macOS

```bash
# Quick run
make mac

# Build and run with verbose output
make verbose run-macos
```

## Testing

### Running Tests

```bash
# Run all tests (iOS and macOS)
make test

# Run iOS tests only
make test-ios

# Run macOS tests only
make test-macos

# Run UI tests
make test-ui-ios

# Run tests with verbose output
make verbose test
```

### Test-Driven Development (TDD)

The generated projects support TDD workflow:

1. Write failing tests first in `YourProject/Tests/`
2. Run tests: `make test-ios`
3. Implement features to make tests pass
4. Refactor while keeping tests green

## Logging and Debugging

### Log Management

All build, test, and run logs are saved to the `logs/` directory:

```bash
# View recent logs
make logs

# Clean log files
make clean-logs

# Logs are organized by type:
logs/
├── build.log    # Build output
├── test.log     # Test results
└── run.log      # Runtime logs
```

### Verbose vs Quiet Mode

```bash
# Verbose mode - see all output
make verbose build-ios
make verbose test

# Quiet mode - minimal output, logs to file
make quiet build-ios
make quiet test

# Set as environment variable
export VERBOSE=1
make build-ios
```

## Installation and Deployment

### Installing on Simulator

```bash
# Build first
make build-ios

# Install on booted simulator
xcrun simctl install booted path/to/YourApp.app

# Or use the generated app path
make install-sim
```

### Installing on Device

```bash
# Connect your device via USB
# Enable Developer Mode on the device

# List devices to get UUID
make list-devices

# Build for device
make build-ios-device

# Install on device
make install-device DEVICE_UUID=<your-device-id>
```

### Creating Archives

```bash
# Create release archive
make archive

# Archive will be in build/YourProject.xcarchive
```

## Requirements

- macOS 13.0+, Xcode 15.0+
- Claude Code CLI (with xcode-build MCP server)
- jq for JSON processing (install: `brew install jq`)
- Note: iOS simulators must match or exceed deployment target version

## Setup Options

The wizard configures:
- **Platforms**: iOS, macOS, watchOS, tvOS, visionOS
- **iOS versions**: 16.0, 17.0, 18.0, 18.3, 18.4, 18.6
- **macOS versions**: 13.0, 14.0, 15.0, 15.4
- **UI Framework**: SwiftUI, UIKit, or both
- **Device targets**: iPhone, iPad, Universal

## Using with Claude Code

When using this template with Claude Code:

1. **Project Generation**: Claude Code will automatically execute the MCP scaffold commands when running `generate_project.sh`
2. **Building & Running**: Use the MCP xcode-build tools directly or via make commands
3. **Non-Interactive Setup**: Use `./setup.sh --config sample.config.json` for automated setup

### Example Claude Code Commands
```bash
# After setup, Claude can directly use:
mcp__xcode-build__build_sim_name_ws
mcp__xcode-build__build_mac_ws
mcp__xcode-build__test_sim_name_ws
```

## Troubleshooting

### Common Issues

**Issue: iOS version mismatch**
- Solution: Ensure your Xcode simulators match the iOS version selected during setup
- Check available simulators: `make list-sims` or `xcrun simctl list`

**Issue: `claude run` command not found**
- Solution: This is expected when running outside Claude Code. The generate_project.sh script will output MCP commands for Claude Code to execute

**Issue: Build fails with "scheme not found"**
- Solution: Run `make schemes` to list available schemes
- Ensure the project was properly scaffolded with MCP tools

**Issue: Simulator doesn't boot**
- Solution: Check simulator availability with `make list-sims`
- Try resetting simulators: `make reset-simulators`

**Issue: Dependencies missing**
- Solution: Run `make check-deps` to verify all required tools are installed
- Install missing dependencies (e.g., `brew install jq`)

## Development

### Repository Structure

```
ios-cc-starter/
├── .claude/                 # Claude configuration for this repo
│   ├── CLAUDE.md.template   # Template for generated CLAUDE.md
│   └── settings.local.json  # MCP server settings (copied to projects)
├── .github/
│   └── workflows/
│       └── ci.yml           # CI/CD for this template repo
├── scripts/                 # Generator scripts
│   ├── generate_project.sh  # Main project generator
│   ├── generate_claude_md.sh
│   └── generate_github_actions.sh
├── templates/               # All template files
│   ├── ios/                 # iOS Swift templates
│   ├── macos/               # macOS Swift templates
│   ├── CLAUDE.md.template   # Alternative CLAUDE.md template
│   ├── test.yml.template    # GitHub Actions template
│   └── .gitignore.template  # Git ignore template
├── tests/
│   └── test_generator.sh    # Generator test suite
├── setup.sh                 # Interactive setup wizard
├── Makefile                 # Build commands
└── sample.config.json       # Example configuration
```

### Testing the Generator

This template repository includes comprehensive tests for the generator itself:

```bash
# Run all generator tests
make test-generator

# Or run directly
./tests/test_generator.sh
```

The test suite validates:
- Project generation with different configurations
- File and directory structure creation
- Template substitution correctness
- Claude configuration files copying
- Custom output directory support

### CI/CD Pipeline

This repository has its own CI/CD pipeline that:
- Runs generator tests on every push and PR
- Validates all template files
- Tests sample project generation
- Lints shell scripts with ShellCheck
- Validates JSON configurations

[![Template CI](https://github.com/prateek/ios-cc-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/prateek/ios-cc-starter/actions/workflows/ci.yml)

## Contributing

Built for [Claude Code Templates](https://github.com/davila7/claude-code-templates). PRs welcome!

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`make test-generator`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

All PRs are automatically tested via GitHub Actions.

## License

MIT