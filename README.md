# iOS/macOS Claude Code Starter

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
✅ GitHub Actions CI/CD ready  
✅ Simple Makefile commands for everything

## What You Get

### Generated Apps
- **iOS**: SwiftUI Hello World with interactive counter, tests, and UI automation
- **macOS**: Native app with menu bar, preferences, and keyboard shortcuts
- **Tests**: Unit, UI, integration, and performance tests included

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

## Contributing

Built for [Claude Code Templates](https://github.com/davila7/claude-code-templates). PRs welcome!

## License

MIT