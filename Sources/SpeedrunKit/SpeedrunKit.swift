/// SpeedrunKit - A comprehensive Swift SDK for the speedrun.com API
///
/// SpeedrunKit provides a type-safe, protocol-oriented interface to the speedrun.com API,
/// enabling developers to easily integrate speedrunning data into their applications.
///
/// ## Overview
///
/// The SDK is built with modern Swift practices including:
/// - Async/await for all network operations
/// - Protocol-oriented design for flexibility and testability
/// - Comprehensive error handling
/// - Full API coverage
/// - Cross-platform support (macOS, iOS, tvOS, watchOS, Linux)
///
/// ## Getting Started
///
/// ```swift
/// import SpeedrunKit
///
/// let client = SpeedrunClient()
/// 
/// // Fetch games
/// let games = try await client.games.list()
/// 
/// // Get a specific game
/// let mario64 = try await client.games.get("sm64")
/// ```

import Foundation

/// The main entry point for the SpeedrunKit SDK
public final class SpeedrunClient: SpeedrunClientProtocol, @unchecked Sendable {
    /// The configuration for the client
    public let configuration: SpeedrunConfiguration
    
    /// The network client used for requests
    private let network: NetworkProtocol
    
    /// Games API operations
    public let games: GamesAPI
    
    /// Categories API operations
    public let categories: CategoriesAPI
    
    /// Levels API operations
    public let levels: LevelsAPI
    
    /// Variables API operations
    public let variables: VariablesAPI
    
    /// Runs API operations
    public let runs: RunsAPI
    
    /// Users API operations
    public let users: UsersAPI
    
    /// Leaderboards API operations
    public let leaderboards: LeaderboardsAPI
    
    /// Series API operations
    public let series: SeriesAPI
    
    /// Platforms API operations
    public let platforms: PlatformsAPI
    
    /// Regions API operations
    public let regions: RegionsAPI
    
    /// Genres API operations
    public let genres: GenresAPI
    
    /// Profile API operations (requires authentication)
    public let profile: ProfileAPI
    
    /// Initialize a new SpeedrunClient
    /// - Parameters:
    ///   - configuration: The configuration for the client (default: .default)
    ///   - network: Optional custom network implementation (default: URLSession-based)
    public init(
        configuration: SpeedrunConfiguration = .default,
        network: NetworkProtocol? = nil
    ) {
        self.configuration = configuration
        self.network = network ?? URLSessionNetwork(configuration: configuration)
        
        // Initialize API sections
        self.games = GamesAPIImpl(network: self.network, configuration: configuration)
        self.categories = CategoriesAPIImpl(network: self.network, configuration: configuration)
        self.levels = LevelsAPIImpl(network: self.network, configuration: configuration)
        self.variables = VariablesAPIImpl(network: self.network, configuration: configuration)
        self.runs = RunsAPIImpl(network: self.network, configuration: configuration)
        self.users = UsersAPIImpl(network: self.network, configuration: configuration)
        self.leaderboards = LeaderboardsAPIImpl(network: self.network, configuration: configuration)
        self.series = SeriesAPIImpl(network: self.network, configuration: configuration)
        self.platforms = PlatformsAPIImpl(network: self.network, configuration: configuration)
        self.regions = RegionsAPIImpl(network: self.network, configuration: configuration)
        self.genres = GenresAPIImpl(network: self.network, configuration: configuration)
        self.profile = ProfileAPIImpl(network: self.network, configuration: configuration)
    }
}
