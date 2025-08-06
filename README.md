# iOS/macOS Claude Code Starter

CLI-driven iOS/macOS development template for Claude Code - no Xcode UI required!

## Quick Start

```bash
# Clone and setup
git clone https://github.com/prateek/ios-cc-starter
cd ios-cc-starter
./setup.sh

# Navigate to your project
cd output/YourProjectName

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
make ios          # Run iOS simulator
make mac          # Run macOS app
make test         # Run all tests
make list-sims    # List simulators
make clean        # Clean build
```

## Requirements

- macOS 13.0+, Xcode 15.0+, Node.js 18+
- Claude Code CLI (with xcode-build MCP server)
- Note: Xcode simulators must match deployment target version

## Setup Options

The wizard configures:
- **Platforms**: iOS, macOS, watchOS, tvOS, visionOS
- **iOS versions**: 16.0, 17.0, 18.0, 18.4
- **macOS versions**: 13.0, 14.0, 15.0, 15.4
- **UI Framework**: SwiftUI, UIKit, or both
- **Device targets**: iPhone, iPad, Universal

## Contributing

Built for [Claude Code Templates](https://github.com/davila7/claude-code-templates). PRs welcome!

## License

MIT