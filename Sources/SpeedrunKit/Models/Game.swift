import Foundation

/// Represents a game on speedrun.com with all its metadata and configuration
public struct Game: ResourceProtocol {
    /// Unique identifier for the game
    public let id: String
    
    /// Game name in different languages
    public let names: Names
    
    /// Short abbreviation used in URLs (can change over time)
    public let abbreviation: String
    
    /// URL to the game's page on speedrun.com
    public let weblink: String
    
    /// Year the game was released (legacy field, use releaseDate instead)
    public let released: Int
    
    /// Full release date of the game
    public let releaseDate: Date?
    
    /// Game-specific rules and requirements
    public let ruleset: Ruleset
    
    /// Legacy field indicating if game is a ROM hack (use gametypes instead)
    public let romhack: Bool
    
    /// List of game type IDs (e.g., ROM hack, fangame)
    public let gametypes: [String]
    
    /// List of platform IDs the game can be played on
    public let platforms: [String]
    
    /// List of region IDs where the game is available
    public let regions: [String]
    
    /// List of genre IDs for the game
    public let genres: [String]
    
    /// List of engine IDs used by the game
    public let engines: [String]
    
    /// List of developer IDs for the game
    public let developers: [String]
    
    /// List of publisher IDs for the game
    public let publishers: [String]
    
    /// Map of user IDs to their moderation roles
    public let moderators: [String: ModeratorRole]
    
    /// When the game was added to speedrun.com (null for old games)
    public let created: Date?
    
    /// Collection of images associated with the game
    public let assets: GameAssets
    
    /// Related API resources
    public let links: [Link]?
    
    /// Embed types supported for games
    public enum Embed: String, CaseIterable {
        case levels
        case categories
        case moderators
        case gametypes
        case platforms
        case regions
        case genres
        case engines
        case developers
        case publishers
        case variables
    }
    
    public typealias EmbedType = Embed
    
    private enum CodingKeys: String, CodingKey {
        case id
        case names
        case abbreviation
        case weblink
        case released
        case releaseDate = "release-date"
        case ruleset
        case romhack
        case gametypes
        case platforms
        case regions
        case genres
        case engines
        case developers
        case publishers
        case moderators
        case created
        case assets
        case links
    }
}

/// Game-specific rules and requirements
public struct Ruleset: Codable, Sendable, Equatable {
    /// Whether to display milliseconds in run times
    public let showMilliseconds: Bool
    
    /// Whether runs require moderator verification
    public let requireVerification: Bool
    
    /// Whether video proof is required for submissions
    public let requireVideo: Bool
    
    /// List of timing methods accepted for this game
    public let runTimes: [TimingMethod]
    
    /// Primary timing method used for ranking
    public let defaultTime: TimingMethod
    
    /// Whether emulator runs are allowed
    public let emulatorsAllowed: Bool
    
    private enum CodingKeys: String, CodingKey {
        case showMilliseconds = "show-milliseconds"
        case requireVerification = "require-verification"
        case requireVideo = "require-video"
        case runTimes = "run-times"
        case defaultTime = "default-time"
        case emulatorsAllowed = "emulators-allowed"
    }
}

/// Timing methods for runs
public enum TimingMethod: String, Codable, Sendable {
    case realtime
    case realtimeNoLoads = "realtime_noloads"
    case ingame
}

/// Moderator roles
public enum ModeratorRole: String, Codable, Sendable {
    case moderator
    case superModerator = "super-moderator"
}

/// Collection of images associated with a game
public struct GameAssets: Codable, Sendable, Equatable {
    /// Game logo
    public let logo: Asset?
    
    /// 32px wide cover image
    public let coverTiny: Asset?
    
    /// 64px wide cover image
    public let coverSmall: Asset?
    
    /// 128px wide cover image
    public let coverMedium: Asset?
    
    /// 256px wide cover image
    public let coverLarge: Asset?
    
    /// Small icon/favicon
    public let icon: Asset?
    
    /// First place trophy icon
    public let trophy1st: Asset?
    
    /// Second place trophy icon
    public let trophy2nd: Asset?
    
    /// Third place trophy icon
    public let trophy3rd: Asset?
    
    /// Fourth place trophy icon (optional)
    public let trophy4th: Asset?
    
    /// Background image for the game page
    public let background: Asset?
    
    /// Foreground image overlay (optional)
    public let foreground: Asset?
    
    private enum CodingKeys: String, CodingKey {
        case logo
        case coverTiny = "cover-tiny"
        case coverSmall = "cover-small"
        case coverMedium = "cover-medium"
        case coverLarge = "cover-large"
        case icon
        case trophy1st = "trophy-1st"
        case trophy2nd = "trophy-2nd"
        case trophy3rd = "trophy-3rd"
        case trophy4th = "trophy-4th"
        case background
        case foreground
    }
}

/// Minimal game representation used in bulk mode
public struct GameBulk: Codable, Sendable {
    /// Unique identifier for the game
    public let id: String
    
    /// Game names
    public let names: Names
    
    /// Short abbreviation used in URLs
    public let abbreviation: String
    
    /// URL to the game's page on speedrun.com
    public let weblink: String
}