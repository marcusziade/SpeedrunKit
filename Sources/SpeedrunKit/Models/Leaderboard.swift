import Foundation

/// A ranked list of runs for a specific category/level
public struct Leaderboard: Codable, Sendable {
    /// URL to view this leaderboard on speedrun.com
    public let weblink: String
    
    /// Game ID
    public let game: String
    
    /// Category ID
    public let category: String
    
    /// Level ID (for individual level leaderboards)
    public let level: String?
    
    /// Platform filter applied
    public let platform: String?
    
    /// Region filter applied
    public let region: String?
    
    /// Emulator filter applied (null=both, true=only emulators, false=no emulators)
    public let emulators: Bool?
    
    /// Whether only runs with video are shown
    public let videoOnly: Bool
    
    /// Primary timing method for sorting
    public let timing: TimingMethod
    
    /// Variable filters applied (variable ID -> value ID)
    public let values: [String: String]
    
    /// Ranked runs on this leaderboard
    public let runs: [RankedRun]
    
    /// Related API resources
    public let links: [Link]?
    
    /// Embed types supported for leaderboards
    public enum Embed: String, CaseIterable {
        case game
        case category
        case level
        case players
        case regions
        case platforms
        case variables
    }
    
    private enum CodingKeys: String, CodingKey {
        case weblink
        case game
        case category
        case level
        case platform
        case region
        case emulators
        case videoOnly = "video-only"
        case timing
        case values
        case runs
        case links
    }
}

/// A run with its ranking on a leaderboard
public struct RankedRun: Codable, Sendable {
    /// Position on leaderboard (multiple runs can share a place)
    public let place: Int
    
    /// The run details
    public let run: Run
}

/// A personal best run with ranking
public struct PersonalBest: Codable, Sendable {
    /// Ranking on the leaderboard
    public let place: Int
    
    /// The run details
    public let run: Run
}