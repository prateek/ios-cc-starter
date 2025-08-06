# iOS/macOS Claude Code Starter Template

A comprehensive template for iOS/macOS development using Claude Code CLI - no Xcode UI required! This template enables pure CLI-driven development with full MCP (Model Context Protocol) integration.

## Features

- 🚀 **Interactive Setup** - Configure your project with a simple wizard
- 📱 **Multi-Platform Support** - iOS, macOS, watchOS, tvOS, and visionOS
- 🧪 **Comprehensive Testing** - Unit tests, UI tests, and integration tests included
- 🤖 **Claude Code Optimized** - Full MCP xcode-build server integration
- 🎯 **Hello World Apps** - Working examples with interactive UI
- 📦 **Zero Xcode UI** - Everything done through CLI
- 🔧 **Makefile Commands** - Simple commands for all operations
- 🔄 **CI/CD Ready** - GitHub Actions workflow included

## Quick Start

1. **Clone this template**
```bash
git clone https://github.com/prateek/ios-cc-starter
cd ios-cc-starter
```

2. **Run the interactive setup**
```bash
./setup.sh
```

3. **Answer configuration questions**
- Project name
- Bundle identifier
- Target platforms (iOS, macOS, etc.)
- Minimum OS versions
- UI framework preference

4. **Start developing**
```bash
cd output/YourProjectName
make help  # See all available commands
make ios   # Run on iOS simulator
make mac   # Run on macOS
```

## Project Structure

```
ios-cc-starter/
├── setup.sh                   # Interactive setup wizard
├── templates/                 # Project templates
│   ├── ios/                  # iOS app templates
│   │   ├── ContentView.swift.template
│   │   ├── App.swift.template
│   │   └── Tests/
│   ├── macos/                # macOS app templates
│   │   ├── ContentView.swift.template
│   │   ├── App.swift.template
│   │   └── Tests/
│   └── configs/              # Configuration templates
├── scripts/                   # Helper scripts
├── .claude/                   # Claude Code configuration
│   └── CLAUDE.md.template    # Project-specific Claude instructions
├── Makefile                   # Common commands
└── .github/                   # GitHub Actions
    └── workflows/
        └── test.yml.template  # CI/CD workflow
```

## Generated Project Features

### Hello World Apps

Each generated project includes:

**iOS App**
- SwiftUI interface with "Hello, World!" text
- Interactive counter with tap/reset buttons
- About dialog with version info
- Full accessibility identifiers for testing

**macOS App**
- Native macOS window with menu bar
- System information display
- Keyboard shortcuts
- Preferences window

### Comprehensive Tests

- **Unit Tests**: Business logic testing with full coverage
- **UI Tests**: Interface testing with element verification
- **Integration Tests**: End-to-end workflow testing
- **Performance Tests**: Launch time and interaction metrics

## Available Commands

Run `make help` in your generated project to see all commands:

```bash
# iOS Development
make build-ios          # Build for simulator
make run-ios           # Run on simulator
make test-ios          # Run iOS tests
make run-ios-device    # Run on physical device

# macOS Development
make build-macos       # Build macOS app
make run-macos         # Run macOS app
make test-macos        # Run macOS tests

# Testing
make test              # Run all tests
make test-ui-ios       # Run iOS UI tests
make lint              # Run SwiftLint
make format            # Format code with SwiftFormat

# Utilities
make clean             # Clean build artifacts
make list-sims         # List available simulators
make list-devices      # List connected devices
make screenshot        # Take simulator screenshot
```

## MCP Integration

This template fully integrates with the xcode-build MCP server, providing:

- Simulator management
- Device deployment
- Build orchestration
- Test execution
- UI automation
- Log capture

## Requirements

- **macOS** 13.0 or later
- **Xcode** 15.0 or later
- **Claude Code** CLI installed
- **Node.js** 18+ (for MCP server)
- **xcode-build MCP** server configured

### Installing Prerequisites

```bash
# Install Claude Code CLI
npm install -g @anthropic/claude-code

# Install xcode-build MCP server
npm install -g @mcp/xcode-build

# Install optional tools
brew install swiftlint swiftformat
```

## Configuration Options

The setup wizard supports:

### Platforms
- iOS (iPhone, iPad, Universal)
- macOS
- watchOS
- tvOS
- visionOS

### UI Frameworks
- SwiftUI (recommended)
- UIKit
- Both

### iOS Versions
- iOS 16.0
- iOS 17.0
- iOS 18.0
- iOS 18.4

### macOS Versions
- macOS 13.0
- macOS 14.0
- macOS 15.0
- macOS 15.4

## Customization

After setup, customize your project by:

1. **Editing CLAUDE.md** - Add project-specific Claude instructions
2. **Modifying Makefile** - Add custom commands
3. **Updating templates** - Customize generated code
4. **Adding dependencies** - Use Swift Package Manager

## CI/CD

The template includes GitHub Actions workflow that:
- Builds all platform targets
- Runs complete test suite
- Generates coverage reports
- Creates release archives

## Contributing

This template is designed to be used with [Claude Code Templates](https://github.com/davila7/claude-code-templates).

To contribute:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Troubleshooting

### Simulator not found
```bash
make list-sims  # List available simulators
SIMULATOR_NAME="iPhone 15" make run-ios  # Use specific simulator
```

### Build failures
```bash
make clean              # Clean build artifacts
make clean-derived-data # Remove all cached data
```

### MCP server issues
```bash
make diagnostic  # Run MCP diagnostic
```

## License

MIT License - see LICENSE file for details

## Support

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [MCP xcode-build Documentation](https://github.com/mcp/xcode-build)
- [Report Issues](https://github.com/prateek/ios-cc-starter/issues)

## Acknowledgments

Built for the Claude Code community to enable pure CLI-driven iOS/macOS development.