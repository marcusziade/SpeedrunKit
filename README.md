# SpeedrunKit

[![Swift](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)](https://swift.org)
[![CI](https://github.com/marcusziade/SpeedrunKit/actions/workflows/ci.yml/badge.svg)](https://github.com/marcusziade/SpeedrunKit/actions/workflows/ci.yml)
[![Documentation](https://img.shields.io/badge/docs-DocC-blue)](https://marcusziade.github.io/SpeedrunKit/documentation/speedrunkit)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

A comprehensive Swift SDK for the [speedrun.com](https://www.speedrun.com) API, providing type-safe access to speedrunning data.

## Features

- 🚀 **Complete API Coverage** - Access to all speedrun.com API endpoints
- 🔒 **Type-Safe** - Leverages Swift's strong type system
- ⚡ **Modern Swift** - Built with async/await and Swift 6.1+
- 🌍 **Cross-Platform** - Works on macOS, iOS, tvOS, watchOS, and Linux
- 🏗️ **Protocol-Oriented** - Flexible and testable architecture
- ⚠️ **Comprehensive Error Handling** - Detailed error types for all failure cases
- 📦 **Zero Dependencies** - Uses only native Swift libraries
- 📖 **Fully Documented** - Complete DocC documentation
- 🧪 **Well Tested** - Comprehensive test suite
- 🐳 **Docker Support** - Ready-to-use Docker images

## Installation

### Swift Package Manager

Add SpeedrunKit to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/marcusziade/SpeedrunKit.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["SpeedrunKit"]
)
```

### Xcode

1. In Xcode, select **File > Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/marcusziade/SpeedrunKit.git`
3. Select the version you want to use

## Quick Start

```swift
import SpeedrunKit

// Create a client
let client = SpeedrunClient()

// Fetch games
let games = try await client.games.list(
    query: GameQuery(name: "Mario", max: 10),
    embeds: [.categories, .levels]
)

// Get a specific game
let sm64 = try await client.games.get("sm64", embeds: [.categories])

// Fetch leaderboard
let leaderboard = try await client.leaderboards.fullGame(
    game: "sm64",
    category: "120-star",
    query: LeaderboardQuery(top: 10),
    embeds: [.players]
)

// Get user details
let user = try await client.users.get("username")

// Get personal bests
let personalBests = try await client.users.personalBests(
    userId: user.id,
    top: 10,
    series: nil,
    game: nil,
    embeds: [.game, .category]
)
```

## Authentication

Some endpoints require authentication. Get an API key from [speedrun.com/api/auth](https://www.speedrun.com/api/auth):

```swift
let config = SpeedrunConfiguration(apiKey: "your-api-key")
let client = SpeedrunClient(configuration: config)

// Now you can use authenticated endpoints
let profile = try await client.profile.getProfile()
let notifications = try await client.profile.getNotifications(
    orderBy: .created,
    direction: .descending
)
```

## Error Handling

SpeedrunKit provides comprehensive error handling:

```swift
do {
    let games = try await client.games.list(query: nil, embeds: nil)
} catch let error as SpeedrunError {
    switch error {
    case .networkError(let underlyingError):
        print("Network error: \(underlyingError)")
    case .httpError(let statusCode, let message):
        print("HTTP \(statusCode): \(message ?? "Unknown error")")
    case .rateLimitExceeded:
        print("Rate limit exceeded, try again later")
    case .authenticationRequired:
        print("This endpoint requires authentication")
    default:
        print("Error: \(error.localizedDescription)")
    }
}
```

## Pagination

Handle paginated responses easily:

```swift
var allGames: [Game] = []
var offset = 0
let pageSize = 200

repeat {
    let page = try await client.games.list(
        query: GameQuery(max: pageSize, offset: offset),
        embeds: nil
    )
    
    allGames.append(contentsOf: page.data)
    
    if page.data.count < pageSize {
        break
    }
    
    offset += pageSize
} while true
```

## CLI Tool

SpeedrunKit includes a CLI tool for testing the API:

```bash
# Build the CLI
swift build --product speedrun-cli -c release

# Run the CLI
.build/release/speedrun-cli
```

## Docker

### Using Docker

```bash
# Build the image
docker build -t speedrunkit .

# Run the CLI
docker run --rm speedrunkit

# Development with docker-compose
docker-compose run dev       # Build the project
docker-compose run test      # Run tests
docker-compose run cli       # Run CLI tool
docker-compose run docs      # Generate documentation
```

### Using Pre-built Images

```bash
docker pull marcusziade/speedrunkit:latest
docker run --rm marcusziade/speedrunkit:latest
```

## API Coverage

SpeedrunKit provides complete coverage of the speedrun.com API:

### Resources
- ✅ Games
- ✅ Categories
- ✅ Levels
- ✅ Variables
- ✅ Runs
- ✅ Users & Guests
- ✅ Leaderboards
- ✅ Series
- ✅ Platforms
- ✅ Regions
- ✅ Genres
- ✅ Engines
- ✅ Developers
- ✅ Publishers
- ✅ Game Types

### Features
- ✅ Pagination
- ✅ Embeds
- ✅ Filtering
- ✅ Sorting
- ✅ Authentication
- ✅ Rate Limit Handling
- ✅ Comprehensive Error Types

## Requirements

- Swift 6.1+
- macOS 12.0+ / iOS 15.0+ / tvOS 15.0+ / watchOS 8.0+ / Linux

## Documentation

Visit our [website](https://marcusziade.github.io/SpeedrunKit/) for an overview, or jump directly to the [API documentation](https://marcusziade.github.io/SpeedrunKit/documentation/speedrunkit)

To generate documentation locally:

```bash
swift package --allow-writing-to-directory ./docs \
    generate-documentation --target SpeedrunKit \
    --output-path ./docs \
    --transform-for-static-hosting \
    --hosting-base-path SpeedrunKit
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Testing

Run the test suite:

```bash
swift test
```

Run specific tests:

```bash
swift test --filter SpeedrunKitTests.NamesTests
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [speedrun.com](https://www.speedrun.com) for providing the API
- The Swift community for excellent tools and libraries

## Author

Marcus Ziadé - [@marcusziade](https://github.com/marcusziade)

## Links

- [Project Website](https://marcusziade.github.io/SpeedrunKit/)
- [API Documentation](https://marcusziade.github.io/SpeedrunKit/documentation/speedrunkit)
- [speedrun.com API Reference](https://github.com/speedruncomorg/api)
- [Report Issues](https://github.com/marcusziade/SpeedrunKit/issues)
- [Releases](https://github.com/marcusziade/SpeedrunKit/releases)