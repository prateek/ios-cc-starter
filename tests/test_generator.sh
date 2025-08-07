#!/bin/bash
# ABOUTME: Test script for validating the project generator functionality
# ABOUTME: Tests directory structure, file copying, and template substitution

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test output directory
TEST_OUTPUT_DIR="test_output"

# Helper functions
test_start() {
    echo -e "${YELLOW}Running: $1${NC}"
    TESTS_RUN=$((TESTS_RUN + 1))
}

test_pass() {
    echo -e "${GREEN}✓ $1${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

test_fail() {
    echo -e "${RED}✗ $1${NC}"
    echo "  Error: $2"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

assert_file_exists() {
    if [ -f "$1" ]; then
        test_pass "File exists: $1"
    else
        test_fail "File exists: $1" "File not found"
        return 1
    fi
}

assert_dir_exists() {
    if [ -d "$1" ]; then
        test_pass "Directory exists: $1"
    else
        test_fail "Directory exists: $1" "Directory not found"
        return 1
    fi
}

assert_file_contains() {
    if grep -q "$2" "$1"; then
        test_pass "File $1 contains: $2"
    else
        test_fail "File $1 contains: $2" "Pattern not found in file"
        return 1
    fi
}

assert_file_not_contains() {
    if ! grep -q "$2" "$1"; then
        test_pass "File $1 does not contain: $2"
    else
        test_fail "File $1 does not contain: $2" "Pattern found in file"
        return 1
    fi
}

# Setup test environment
setup_test() {
    echo "Setting up test environment..."
    
    # Clean up previous test output
    rm -rf "$TEST_OUTPUT_DIR"
    mkdir -p "$TEST_OUTPUT_DIR"
    
    # Create a test configuration
    cat > project.config.json << 'EOF'
{
  "projectName": "TestApp",
  "bundleId": "com.test.testapp",
  "displayName": "Test Application",
  "platforms": ["ios", "macos"],
  "uiFramework": "SwiftUI",
  "iosConfig": {
    "minVersion": "17.0",
    "deviceFamily": "universal"
  },
  "macosConfig": {
    "minVersion": "14.0"
  },
  "includeCI": true,
  "includeTests": true
}
EOF
}

# Cleanup test environment
cleanup_test() {
    echo "Cleaning up test environment..."
    rm -rf "$TEST_OUTPUT_DIR"
    rm -f project.config.json
}

# Test 1: Basic project generation
test_basic_generation() {
    test_start "Basic project generation"
    
    # Run the generator with test output directory
    ./scripts/generate_project.sh "$TEST_OUTPUT_DIR"
    
    # Check if output directory was created
    assert_dir_exists "$TEST_OUTPUT_DIR/TestApp"
}

# Test 2: Check required files are copied
test_required_files() {
    test_start "Required files are copied"
    
    # Check for essential files
    assert_file_exists "$TEST_OUTPUT_DIR/TestApp/Makefile"
    assert_file_exists "$TEST_OUTPUT_DIR/TestApp/.gitignore"
    assert_file_exists "$TEST_OUTPUT_DIR/TestApp/README.md"
    assert_dir_exists "$TEST_OUTPUT_DIR/TestApp/.claude"
    assert_file_exists "$TEST_OUTPUT_DIR/TestApp/.claude/CLAUDE.md"
}

# Test 3: Check .claude files are copied
test_claude_files() {
    test_start "Claude configuration files are copied"
    
    # Check if settings.local.json was copied
    if [ -f ".claude/settings.local.json" ]; then
        assert_file_exists "$TEST_OUTPUT_DIR/TestApp/.claude/settings.local.json"
    else
        echo "  Note: .claude/settings.local.json not present in source, skipping"
    fi
    
    # Check CLAUDE.md exists and has substitutions
    assert_file_exists "$TEST_OUTPUT_DIR/TestApp/.claude/CLAUDE.md"
}

# Test 4: Check template substitutions
test_template_substitutions() {
    test_start "Template substitutions are performed"
    
    # Check Makefile substitution
    assert_file_contains "$TEST_OUTPUT_DIR/TestApp/Makefile" "PROJECT_NAME ?= TestApp"
    
    # Check README contains project name
    assert_file_contains "$TEST_OUTPUT_DIR/TestApp/README.md" "TestApp"
    assert_file_contains "$TEST_OUTPUT_DIR/TestApp/README.md" "com.test.testapp"
    
    # Check CLAUDE.md substitutions
    assert_file_contains "$TEST_OUTPUT_DIR/TestApp/.claude/CLAUDE.md" "TestApp"
    assert_file_not_contains "$TEST_OUTPUT_DIR/TestApp/.claude/CLAUDE.md" "{{PROJECT_NAME}}"
    
    # Check .gitignore substitutions
    assert_file_not_contains "$TEST_OUTPUT_DIR/TestApp/.gitignore" "{{PROJECT_NAME}}"
}

# Test 5: Check Swift source files
test_swift_sources() {
    test_start "Swift source files are generated"
    
    # Check iOS sources
    if [ -d "$TEST_OUTPUT_DIR/TestApp/TestApp/Sources" ]; then
        assert_dir_exists "$TEST_OUTPUT_DIR/TestApp/TestApp/Sources"
        # Check for template substitutions in Swift files
        for swift_file in "$TEST_OUTPUT_DIR/TestApp/TestApp/Sources"/*.swift; do
            if [ -f "$swift_file" ]; then
                assert_file_not_contains "$swift_file" "{{PROJECT_NAME}}"
                assert_file_not_contains "$swift_file" "{{BUNDLE_ID}}"
            fi
        done
    fi
    
    # Check macOS sources
    if [ -d "$TEST_OUTPUT_DIR/TestApp/TestAppMac/Sources" ]; then
        assert_dir_exists "$TEST_OUTPUT_DIR/TestApp/TestAppMac/Sources"
    fi
}

# Test 6: Check test files
test_test_files() {
    test_start "Test files are generated"
    
    # Check iOS tests
    if [ -d "$TEST_OUTPUT_DIR/TestApp/TestApp/Tests" ]; then
        assert_dir_exists "$TEST_OUTPUT_DIR/TestApp/TestApp/Tests"
        # Check for test files
        for test_file in "$TEST_OUTPUT_DIR/TestApp/TestApp/Tests"/*.swift; do
            if [ -f "$test_file" ]; then
                assert_file_not_contains "$test_file" "{{PROJECT_NAME}}"
            fi
        done
    fi
}

# Test 7: Check CI configuration
test_ci_configuration() {
    test_start "CI configuration is generated"
    
    # Check if GitHub Actions workflow was created
    if [ -d "$TEST_OUTPUT_DIR/TestApp/.github/workflows" ]; then
        assert_dir_exists "$TEST_OUTPUT_DIR/TestApp/.github/workflows"
        assert_file_exists "$TEST_OUTPUT_DIR/TestApp/.github/workflows/test.yml"
        
        # Check template substitutions in workflow
        assert_file_contains "$TEST_OUTPUT_DIR/TestApp/.github/workflows/test.yml" "TestApp"
        assert_file_not_contains "$TEST_OUTPUT_DIR/TestApp/.github/workflows/test.yml" "{{PROJECT_NAME}}"
    fi
}

# Test 8: Custom output directory
test_custom_output_dir() {
    test_start "Custom output directory works"
    
    # Test with a different output directory
    CUSTOM_DIR="custom_test_output"
    rm -rf "$CUSTOM_DIR"
    
    ./scripts/generate_project.sh "$CUSTOM_DIR"
    
    assert_dir_exists "$CUSTOM_DIR/TestApp"
    assert_file_exists "$CUSTOM_DIR/TestApp/Makefile"
    
    # Cleanup
    rm -rf "$CUSTOM_DIR"
}

# Main test execution
main() {
    echo "========================================"
    echo "iOS/macOS Starter Template Generator Tests"
    echo "========================================"
    echo ""
    
    # Setup
    setup_test
    
    # Run tests
    test_basic_generation
    test_required_files
    test_claude_files
    test_template_substitutions
    test_swift_sources
    test_test_files
    test_ci_configuration
    test_custom_output_dir
    
    # Cleanup
    cleanup_test
    
    # Report results
    echo ""
    echo "========================================"
    echo "Test Results"
    echo "========================================"
    echo -e "Tests run: $TESTS_RUN"
    echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
    
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "${RED}Tests failed: $TESTS_FAILED${NC}"
        echo ""
        echo -e "${RED}TESTS FAILED${NC}"
        exit 1
    else
        echo ""
        echo -e "${GREEN}ALL TESTS PASSED!${NC}"
        exit 0
    fi
}

# Run tests if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi