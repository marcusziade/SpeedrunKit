# SpeedrunKit

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)](https://swift.org)
[![CI](https://github.com/marcusziade/SpeedrunKit/actions/workflows/ci.yml/badge.svg)](https://github.com/marcusziade/SpeedrunKit/actions/workflows/ci.yml)
[![Documentation](https://img.shields.io/badge/docs-DocC-blue)](https://marcusziade.github.io/SpeedrunKit/documentation/speedrunkit)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

A comprehensive Swift SDK for the [speedrun.com](https://www.speedrun.com) API, providing type-safe access to speedrunning data.

## Features

- 🚀 **Complete API Coverage** - All speedrun.com API endpoints
- 🔒 **Type-Safe** - Leverages Swift's strong type system
- ⚡ **Modern Swift** - Built with async/await and Swift 5.9
- 🌍 **Cross-Platform** - macOS, iOS, tvOS, watchOS, and Linux
- 📦 **Zero Dependencies** - Uses only native Swift libraries
- 📖 **Fully Documented** - Complete DocC documentation

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

## Documentation & Resources

- 📚 **[Full API Documentation](https://marcusziade.github.io/SpeedrunKit/documentation/speedrunkit)** - Comprehensive API reference
- 📖 **[Command Manual](manual.md)** - Complete guide to all CLI features and commands
- 🔧 **[Examples & Tutorials](https://marcusziade.github.io/SpeedrunKit/)** - Learn how to use SpeedrunKit
- 🐛 **[Report Issues](https://github.com/marcusziade/SpeedrunKit/issues)** - Found a bug? Let us know!


## Quick Examples

### Error Handling

```swift
do {
    let games = try await client.games.list(query: nil, embeds: nil)
} catch let error as SpeedrunError {
    print("Error: \(error.localizedDescription)")
}
```

### Pagination

```swift
// Fetch multiple pages
let page1 = try await client.games.list(query: GameQuery(max: 20, offset: 0), embeds: nil)
let page2 = try await client.games.list(query: GameQuery(max: 20, offset: 20), embeds: nil)
```

For more detailed examples, see the [Command Manual](manual.md).



## Requirements

- Swift 5.9
- macOS 12.0+ / iOS 15.0+ / tvOS 15.0+ / watchOS 8.0+ / Linux / Android

## CLI & Docker

SpeedrunKit includes a comprehensive CLI tool and Docker support. See the [Command Manual](manual.md) for:
- Building and running the CLI
- Docker and docker-compose usage
- Installation instructions
- All available commands

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

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
- [Command Manual](manual.md) - All CLI features and commands
- [speedrun.com API Reference](https://github.com/speedruncomorg/api)
- [Report Issues](https://github.com/marcusziade/SpeedrunKit/issues)
