# ``SpeedrunKit``

A comprehensive Swift SDK for the speedrun.com API with full async/await support and cross-platform compatibility.

## Overview

SpeedrunKit provides a complete, type-safe interface to the speedrun.com API, enabling Swift developers to build powerful speedrunning applications and tools. Whether you're building a leaderboard viewer, run submission tool, or analytics platform, SpeedrunKit has you covered with a modern, protocol-oriented architecture.

## Features

- **Complete API Coverage**: Access to all speedrun.com API endpoints
- **Type-Safe**: Strong typing with Swift's type system
- **Modern Swift**: Built with async/await and Swift 5.9+
- **Cross-Platform**: Works on macOS, iOS, tvOS, watchOS, and Linux
- **Protocol-Oriented**: Flexible and testable architecture
- **Comprehensive Error Handling**: Detailed error types for all failure cases
- **No External Dependencies**: Uses only native Swift libraries

## Getting Started

Add SpeedrunKit to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/guitaripod/SpeedrunKit.git", from: "1.0.0")
]
```

Then import and use:

```swift
import SpeedrunKit

let client = SpeedrunClient()

// Fetch games
let games = try await client.games.list(
    query: GameQuery(name: "Mario", max: 10),
    embeds: [.categories, .levels]
)

// Get leaderboard
let leaderboard = try await client.leaderboards.fullGame(
    game: "sm64",
    category: "any-percent",
    query: LeaderboardQuery(top: 10),
    embeds: [.players]
)
```

## Topics

### Essentials

- ``SpeedrunClient``
- ``SpeedrunConfiguration``
- ``SpeedrunError``

### Games & Categories

- ``Game``
- ``Category``
- ``Level``
- ``Variable``

### Runs & Leaderboards

- ``Run``
- ``RunSubmit``
- ``Leaderboard``
- ``PersonalBest``

### Users & Authentication

- ``User``
- ``Guest``
- ``Notification``

### Metadata

- ``Series``
- ``Platform``
- ``Region``
- ``Genre``
- ``Engine``
- ``Developer``
- ``Publisher``
- ``GameType``

### API Protocols

- ``GamesAPI``
- ``CategoriesAPI``
- ``LevelsAPI``
- ``VariablesAPI``
- ``RunsAPI``
- ``UsersAPI``
- ``LeaderboardsAPI``
- ``SeriesAPI``
- ``PlatformsAPI``
- ``RegionsAPI``
- ``GenresAPI``
- ``ProfileAPI``

### Networking

- ``NetworkProtocol``
- ``Endpoint``
- ``HTTPMethod``

### Common Types

- ``Link``
- ``Names``
- ``Asset``
- ``Color``
- ``Location``
- ``Pagination``
- ``PaginatedResponse``
- ``PaginatedData``