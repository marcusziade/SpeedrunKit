import Foundation

/// A speedrun category defining a specific ruleset
public struct Category: ResourceProtocol {
    /// Unique identifier for the category
    public let id: String
    
    /// Category name (e.g., 'Any%', '100%')
    public let name: String
    
    /// URL to the category leaderboard on speedrun.com
    public let weblink: String
    
    /// Whether this category applies to full game or individual level runs
    public let type: CategoryType
    
    /// Freeform text describing the category rules
    public let rules: String?
    
    /// Number of players required/allowed
    public let players: Players
    
    /// Whether this is a miscellaneous category (not shown on main leaderboards)
    public let miscellaneous: Bool
    
    /// Related API resources
    public let links: [Link]?
    
    /// Embed types supported for categories
    public enum Embed: String, CaseIterable {
        case game
        case variables
    }
    
    public typealias EmbedType = Embed
}

/// Category type
public enum CategoryType: String, Codable, Sendable {
    case perGame = "per-game"
    case perLevel = "per-level"
}

/// Player requirements for a category
public struct Players: Codable, Sendable, Equatable {
    /// Whether the value is exact or maximum
    public let type: PlayerType
    
    /// Number of players
    public let value: Int
    
    /// Player requirement type
    public enum PlayerType: String, Codable, Sendable {
        case exactly
        case upTo = "up-to"
    }
}