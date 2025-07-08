# Getting Started with SpeedrunKit

Learn how to integrate SpeedrunKit into your project and start fetching speedrun data.

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
4. Add SpeedrunKit to your desired targets

## Basic Usage

### Creating a Client

```swift
import SpeedrunKit

// Create with default configuration
let client = SpeedrunClient()

// Create with custom configuration
let config = SpeedrunConfiguration(
    apiKey: "your-api-key",  // Optional, for authenticated endpoints
    timeoutInterval: 60,
    debugLogging: true
)
let customClient = SpeedrunClient(configuration: config)
```

### Fetching Games

```swift
// List all games
let games = try await client.games.list(
    query: GameQuery(max: 20),
    embeds: nil
)

// Search for games
let marioGames = try await client.games.list(
    query: GameQuery(name: "Mario", max: 10),
    embeds: [.categories, .moderators]
)

// Get a specific game
let sm64 = try await client.games.get("sm64", embeds: [.categories, .levels, .variables])
```

### Working with Categories

```swift
// Get categories for a game
let categories = try await client.games.categories(
    gameId: "sm64",
    miscellaneous: false,
    orderBy: .pos,
    direction: .ascending
)

// Get specific category details
let anyPercent = try await client.categories.get("category-id", embeds: [.game, .variables])
```

### Fetching Leaderboards

```swift
// Get full-game leaderboard
let leaderboard = try await client.leaderboards.fullGame(
    game: "sm64",
    category: "any-percent",
    query: LeaderboardQuery(
        top: 100,
        platform: "platform-id",
        emulators: false
    ),
    embeds: [.players, .game, .category]
)

// Get individual-level leaderboard
let levelLeaderboard = try await client.leaderboards.level(
    game: "sm64",
    level: "bob-omb-battlefield",
    category: "star-1",
    query: LeaderboardQuery(top: 50),
    embeds: [.players]
)
```

### Working with Users

```swift
// Get user details
let user = try await client.users.get("username")

// Get user's personal bests
let personalBests = try await client.users.personalBests(
    userId: "user-id",
    top: 10,
    series: nil,
    game: "sm64",
    embeds: [.game, .category, .level]
)
```

### Handling Errors

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
} catch {
    print("Unexpected error: \(error)")
}
```

### Using Embeds

Many endpoints support embedding related resources to reduce API calls:

```swift
// Embed multiple resources
let game = try await client.games.get(
    "sm64",
    embeds: [.categories, .levels, .moderators, .platforms]
)

// Access embedded data directly
for category in game.categories ?? [] {
    print("Category: \(category.name)")
}
```

### Pagination

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

## Authentication

Some endpoints require authentication. To use these endpoints:

1. Get an API key from [speedrun.com/api/auth](https://www.speedrun.com/api/auth)
2. Create a client with the API key:

```swift
let config = SpeedrunConfiguration(apiKey: "your-api-key")
let client = SpeedrunClient(configuration: config)

// Now you can use authenticated endpoints
let profile = try await client.profile.getProfile()
let notifications = try await client.profile.getNotifications(orderBy: .created, direction: .descending)
```

## Next Steps

- Explore the full API documentation
- Check out the example CLI tool in the repository
- Read about advanced features like custom networking implementations