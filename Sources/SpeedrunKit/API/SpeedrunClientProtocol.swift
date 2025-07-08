import Foundation

/// Main protocol defining the Speedrun.com API client interface
public protocol SpeedrunClientProtocol: Sendable {
    /// Games API operations
    var games: GamesAPI { get }
    
    /// Categories API operations
    var categories: CategoriesAPI { get }
    
    /// Levels API operations
    var levels: LevelsAPI { get }
    
    /// Variables API operations
    var variables: VariablesAPI { get }
    
    /// Runs API operations
    var runs: RunsAPI { get }
    
    /// Users API operations
    var users: UsersAPI { get }
    
    /// Leaderboards API operations
    var leaderboards: LeaderboardsAPI { get }
    
    /// Series API operations
    var series: SeriesAPI { get }
    
    /// Platforms API operations
    var platforms: PlatformsAPI { get }
    
    /// Regions API operations
    var regions: RegionsAPI { get }
    
    /// Genres API operations
    var genres: GenresAPI { get }
    
    /// Profile API operations (requires authentication)
    var profile: ProfileAPI { get }
}

/// Protocol for API sections
public protocol APISection: Sendable {
    /// The network client used for requests
    var network: NetworkProtocol { get }
    
    /// The configuration for the API
    var configuration: SpeedrunConfiguration { get }
}