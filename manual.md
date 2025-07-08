# SpeedrunKit Command Manual

This manual contains all available commands for building, testing, and using SpeedrunKit with their outputs.

## Table of Contents

- [Building Commands](#building-commands)
- [Testing Commands](#testing-commands)
- [CLI Commands](#cli-commands)
- [Documentation Commands](#documentation-commands)
- [Docker Commands](#docker-commands)
- [Package Management](#package-management)
- [Git Operations](#git-operations)

---

## Building Commands

<details>
<summary>🔨 Basic Build</summary>

```bash
swift build
```

**Output:**
```
Fetching https://github.com/swiftlang/swift-docc-symbolkit from cache
Fetching https://github.com/swiftlang/swift-docc-plugin from cache
Fetched https://github.com/swiftlang/swift-docc-plugin from cache (0.00s)
Fetched https://github.com/swiftlang/swift-docc-symbolkit from cache (0.01s)
Creating working copy for https://github.com/swiftlang/swift-docc-symbolkit
Working copy of https://github.com/swiftlang/swift-docc-symbolkit resolved at 1.0.0
Creating working copy for https://github.com/swiftlang/swift-docc-plugin
Working copy of https://github.com/swiftlang/swift-docc-plugin resolved at 1.4.5
[1/1] Compiling plugin Swift-DocC Preview
[2/2] Compiling plugin Swift-DocC
Building for debugging...
[2/9] Write sources
[4/9] Write swift-version-5BD8B568FD16BF8B.txt
[6/54] Compiling SpeedrunKit Genre.swift
[7/54] Compiling SpeedrunKit Leaderboard.swift
...
[58/59] Linking speedrun-cli
Build complete! (9.20s)
```

</details>

<details>
<summary>🔨 Build with Verbose Output</summary>

```bash
swift build -v
```

Shows detailed compilation steps and flags used by the Swift compiler.

</details>

<details>
<summary>🔨 Build Release Version</summary>

```bash
swift build -c release
```

Builds optimized release binaries without debug symbols.

</details>

<details>
<summary>🔨 Build Specific Product</summary>

```bash
swift build --product SpeedrunKit
swift build --product speedrun-cli
```

Builds only the specified product (library or executable).

</details>

<details>
<summary>🔨 Build CLI Tool for Release</summary>

```bash
swift build --product speedrun-cli -c release
```

**Output:**
```
Building for production...
[0/5] Write sources
[2/5] Write swift-version-5BD8B568FD16BF8B.txt
[4/6] Compiling SpeedrunKit CategoriesAPI.swift
[5/7] Compiling SpeedrunCLI main.swift
[5/7] Write Objects.LinkFileList
[6/7] Linking speedrun-cli
Build of product 'speedrun-cli' complete! (5.61s)
```

</details>

<details>
<summary>🔨 Clean Build</summary>

```bash
swift package clean
swift build
```

Removes all build artifacts and rebuilds from scratch.

</details>

---

## Testing Commands

<details>
<summary>🧪 Run All Tests</summary>

```bash
swift test
```

**Output:**
```
[0/1] Planning build
[1/1] Compiling plugin Swift-DocC Preview
[2/2] Compiling plugin Swift-DocC
Building for debugging...
...
Test Suite 'All tests' started at 2025-07-08 15:43:50.174
Test Suite 'debug.xctest' started at 2025-07-08 15:43:50.177
Test Suite 'AssetTests' started at 2025-07-08 15:43:50.177
Test Case 'AssetTests.testDecoding' started at 2025-07-08 15:43:50.177
Test Case 'AssetTests.testDecoding' passed (0.0 seconds)
...
Test Suite 'All tests' passed at 2025-07-08 15:43:50.381
	 Executed 40 tests, with 0 failures (0 unexpected) in 0.204 (0.204) seconds
◇ Test run started.
↳ Testing Library Version: 6.1 (43b6f88e2f2712e)
↳ Target Platform: x86_64-unknown-linux-gnu
✔ Test run with 0 tests passed after 0.001 seconds.
```

</details>

<details>
<summary>🧪 Run Tests with Verbose Output</summary>

```bash
swift test -v
```

Shows detailed test execution with compiler flags and individual test progress.

</details>

<details>
<summary>🧪 Run Specific Test Suite</summary>

```bash
swift test --filter SpeedrunKitTests.NamesTests
```

Runs only tests matching the specified filter pattern.

</details>

<details>
<summary>🧪 Run Tests in Parallel</summary>

```bash
swift test --parallel
```

Executes test suites in parallel for faster execution.

</details>

<details>
<summary>🧪 Generate Test Coverage</summary>

```bash
swift test --enable-code-coverage
```

Generates code coverage data that can be analyzed with tools like `xcov` or `llvm-cov`.

</details>

<details>
<summary>🧪 List Available Tests</summary>

```bash
swift test --list-tests
```

Lists all available test cases without running them.

</details>

---

## CLI Commands

<details>
<summary>💻 Run CLI Tool (Debug)</summary>

```bash
.build/debug/speedrun-cli
```

Runs the debug version of the CLI tool.

</details>

<details>
<summary>💻 Run CLI Tool (Release)</summary>

```bash
.build/release/speedrun-cli
```

**Output:**
```
🏃 SpeedrunKit CLI Tool
=======================
Testing all speedrun.com API features

Starting API tests...

📦 Testing Games API...
  • Listing games...

❌ Error: dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "data", intValue: nil), _CodingKey(stringValue: "Index 0", intValue: 0)], debugDescription: "Expected date string to be ISO8601-formatted.", underlyingError: nil))
```

*Note: The error indicates an API response format issue that needs investigation.*

</details>

<details>
<summary>💻 Run CLI with API Key</summary>

```bash
SPEEDRUN_API_KEY="your-api-key" .build/release/speedrun-cli
```

Runs the CLI with authentication for endpoints that require it.

</details>

<details>
<summary>💻 Install CLI System-wide</summary>

```bash
# Build release version
swift build --product speedrun-cli -c release

# Copy to /usr/local/bin (requires sudo)
sudo cp .build/release/speedrun-cli /usr/local/bin/

# Or copy to user's bin directory
mkdir -p ~/.local/bin
cp .build/release/speedrun-cli ~/.local/bin/
```

</details>

---

## Documentation Commands

<details>
<summary>📚 Generate Documentation</summary>

```bash
swift package generate-documentation --target SpeedrunKit
```

**Output:**
```
Building for debugging...
[0/9] Write sources
[3/9] Write swift-version-5BD8B568FD16BF8B.txt
[5/11] Emitting module Snippets
[6/12] Wrapping AST for Snippets for debugging
[8/12] Emitting module SymbolKit
[9/13] Wrapping AST for SymbolKit for debugging
...
Building documentation for 'SpeedrunKit'...
Finished building documentation for 'SpeedrunKit' (0.56s)
Generated documentation archive at:
  /home/marcus/Dev/swift/SpeedrunKit/.build/plugins/Swift-DocC/outputs/SpeedrunKit.doccarchive
```

</details>

<details>
<summary>📚 Generate Static Documentation Website</summary>

```bash
swift package --allow-writing-to-directory ./docs \
    generate-documentation --target SpeedrunKit \
    --output-path ./docs \
    --transform-for-static-hosting \
    --hosting-base-path SpeedrunKit
```

Generates a static website suitable for GitHub Pages hosting.

</details>

<details>
<summary>📚 Preview Documentation Locally</summary>

```bash
swift package --disable-sandbox preview-documentation --target SpeedrunKit
```

Opens documentation in your browser with live reloading.

</details>

<details>
<summary>📚 Generate Documentation with Custom Base URL</summary>

```bash
swift package --allow-writing-to-directory ./docs \
    generate-documentation --target SpeedrunKit \
    --output-path ./docs \
    --transform-for-static-hosting \
    --hosting-base-path SpeedrunKit \
    --host-url https://marcusziade.github.io
```

</details>

---

## Docker Commands

<details>
<summary>🐳 Build Docker Image</summary>

```bash
docker build -t speedrunkit .
```

**Output:**
```
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon    215kB
Step 1/18 : FROM swift:6.1-jammy AS builder
6.1-jammy: Pulling from library/swift
...
Status: Downloaded newer image for swift:6.1-jammy
 ---> de5357f4619a
Step 2/18 : RUN apt-get update && apt-get install -y     libcurl4-openssl-dev     libssl-dev     && rm -rf /var/lib/apt/lists/*
...
```

</details>

<details>
<summary>🐳 Build Multi-platform Docker Image</summary>

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t speedrunkit .
```

Builds images for both Intel and ARM architectures.

</details>

<details>
<summary>🐳 Run Docker Container</summary>

```bash
# Run CLI tool
docker run --rm speedrunkit

# Run with API key
docker run --rm -e SPEEDRUN_API_KEY="your-key" speedrunkit

# Run interactive shell
docker run --rm -it speedrunkit /bin/bash
```

</details>

<details>
<summary>🐳 Docker Compose Commands</summary>

```bash
# Build the project
docker-compose run --rm dev

# Run tests
docker-compose run --rm test

# Run CLI tool
docker-compose run --rm cli

# Generate documentation
docker-compose run --rm docs

# Run with custom command
docker-compose run --rm dev swift build --product SpeedrunKit
```

**Output for `docker-compose run --rm dev`:**
```
time="2025-07-08T15:46:29+03:00" level=warning msg="/home/marcus/Dev/swift/SpeedrunKit/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
 Network speedrunkit_default  Creating
 Network speedrunkit_default  Created
 Volume "speedrunkit_swift-build-cache"  Creating
 Volume "speedrunkit_swift-build-cache"  Created
...
```

</details>

<details>
<summary>🐳 Push to Docker Hub</summary>

```bash
# Tag the image
docker tag speedrunkit marcusziade/speedrunkit:latest
docker tag speedrunkit marcusziade/speedrunkit:1.0.0

# Login to Docker Hub
docker login

# Push the images
docker push marcusziade/speedrunkit:latest
docker push marcusziade/speedrunkit:1.0.0
```

</details>

<details>
<summary>🐳 Clean Docker Resources</summary>

```bash
# Remove containers
docker-compose down

# Remove volumes
docker-compose down -v

# Remove images
docker rmi speedrunkit

# Clean all Docker resources
docker system prune -a
```

</details>

---

## Package Management

<details>
<summary>📦 Update Dependencies</summary>

```bash
swift package update
```

Updates all package dependencies to their latest compatible versions.

</details>

<details>
<summary>📦 Resolve Dependencies</summary>

```bash
swift package resolve
```

Resolves package dependencies without building.

</details>

<details>
<summary>📦 Show Dependencies</summary>

```bash
swift package show-dependencies
```

Displays the complete dependency tree.

</details>

<details>
<summary>📦 Generate Xcode Project</summary>

```bash
swift package generate-xcodeproj
```

Creates an Xcode project file (deprecated in favor of opening Package.swift directly).

</details>

<details>
<summary>📦 Reset Package</summary>

```bash
swift package reset
```

Removes all build products and dependencies.

</details>

<details>
<summary>📦 Describe Package</summary>

```bash
swift package describe
```

Shows detailed information about the package structure.

</details>

---

## Git Operations

<details>
<summary>🔧 Initialize Git Repository</summary>

```bash
git init
git add .
git commit -m "Initial commit"
```

</details>

<details>
<summary>🔧 Create and Push to GitHub</summary>

```bash
# Create repository on GitHub first, then:
git remote add origin https://github.com/marcusziade/SpeedrunKit.git
git branch -M main
git push -u origin main
```

</details>

<details>
<summary>🔧 Tag a Release</summary>

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag to remote
git push origin v1.0.0

# Push all tags
git push --tags
```

</details>

<details>
<summary>🔧 Create Pull Request</summary>

```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push branch
git push -u origin feature/new-feature

# Create PR using GitHub CLI
gh pr create --title "Add new feature" --body "Description of changes"
```

</details>

---

## Additional Commands

<details>
<summary>🛠️ Swift Version Info</summary>

```bash
swift --version
```

**Output:**
```
Swift version 6.1 (swift-6.1-RELEASE)
Target: x86_64-unknown-linux-gnu
```

</details>

<details>
<summary>🛠️ Package Tools Version</summary>

```bash
swift package tools-version
```

Shows the Swift tools version required by the package.

</details>

<details>
<summary>🛠️ Format Code</summary>

```bash
# Install swift-format first
git clone https://github.com/swiftlang/swift-format
cd swift-format
swift build -c release
cd ..

# Format code
./swift-format/.build/release/swift-format format --recursive Sources Tests
```

</details>

<details>
<summary>🛠️ Lint Code</summary>

```bash
# Using swift-format
./swift-format/.build/release/swift-format lint --recursive Sources Tests
```

</details>

<details>
<summary>🛠️ Run SwiftLint</summary>

```bash
# Install SwiftLint first
brew install swiftlint  # macOS
# or
docker run --rm -v $(pwd):/code ghcr.io/realm/swiftlint

# Run linting
swiftlint
```

</details>

---

## Troubleshooting

<details>
<summary>❓ Common Issues and Solutions</summary>

### Build Errors

**Issue:** `error: missing required module 'FoundationNetworking'`
**Solution:** This occurs on Linux. The code already handles this with conditional imports.

**Issue:** `error: cannot find 'URLSession' in scope`
**Solution:** On Linux, ensure you have the proper imports:
```swift
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
```

### Test Failures

**Issue:** Tests fail with encoding/decoding errors
**Solution:** Check that your JSON test data matches the expected format exactly.

### Docker Issues

**Issue:** `permission denied` errors
**Solution:** Run Docker commands with `sudo` or add your user to the docker group:
```bash
sudo usermod -aG docker $USER
```

### API Errors

**Issue:** Rate limit exceeded
**Solution:** The SDK handles rate limits automatically with retries. For heavy usage, add delays between requests.

**Issue:** Authentication required
**Solution:** Set the `SPEEDRUN_API_KEY` environment variable or pass it to the configuration.

</details>

---

## Performance Tips

<details>
<summary>⚡ Optimization Commands</summary>

### Build Performance

```bash
# Use release mode for production
swift build -c release

# Enable whole module optimization
swift build -c release -Xswiftc -O -Xswiftc -whole-module-optimization

# Use parallel builds
swift build --jobs 8
```

### Test Performance

```bash
# Run tests in parallel
swift test --parallel

# Skip slow tests
swift test --skip "SlowTests"
```

### Docker Performance

```bash
# Use BuildKit for faster builds
DOCKER_BUILDKIT=1 docker build -t speedrunkit .

# Use cache mounts
docker build --build-arg BUILDKIT_INLINE_CACHE=1 -t speedrunkit .
```

</details>

---

## Environment Variables

<details>
<summary>🔐 Configuration Variables</summary>

```bash
# API Key for authenticated endpoints
export SPEEDRUN_API_KEY="your-api-key"

# Custom API base URL (for testing)
export SPEEDRUN_API_BASE_URL="https://www.speedrun.com/api/v1"

# Request timeout in seconds
export SPEEDRUN_REQUEST_TIMEOUT="30"

# Maximum retry attempts
export SPEEDRUN_MAX_RETRIES="3"

# Enable debug logging
export SPEEDRUN_DEBUG="true"
```

</details>

---

## Quick Reference

<details>
<summary>📋 Command Cheatsheet</summary>

```bash
# Building
swift build                           # Debug build
swift build -c release               # Release build
swift build --product speedrun-cli   # Build specific product

# Testing
swift test                           # Run all tests
swift test --filter NamesTests       # Run specific tests
swift test --parallel                # Parallel execution

# Documentation
swift package generate-documentation --target SpeedrunKit

# Docker
docker build -t speedrunkit .        # Build image
docker run --rm speedrunkit          # Run container
docker-compose run --rm test         # Run tests in Docker

# Package Management
swift package update                 # Update dependencies
swift package resolve                # Resolve dependencies
swift package clean                  # Clean build

# CLI Usage
.build/release/speedrun-cli          # Run CLI
SPEEDRUN_API_KEY=xxx speedrun-cli    # Run with API key
```

</details>

---

## Contributing

For contributing guidelines, please see the main [README.md](README.md#contributing) file.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.