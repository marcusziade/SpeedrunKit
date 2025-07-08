import Foundation

/// A speedrun attempt/submission
public struct Run: ResourceProtocol {
    /// Unique identifier for the run
    public let id: String
    
    /// URL to view this run on speedrun.com
    public let weblink: String
    
    /// Game ID
    public let game: String
    
    /// Level ID for individual level runs
    public let level: String?
    
    /// Category ID
    public let category: String
    
    /// Video links for the run
    public let videos: RunVideos?
    
    /// Runner's comment about the run
    public let comment: String?
    
    /// Verification status of the run
    public let status: RunStatus
    
    /// Players who performed the run
    public let players: [RunPlayer]
    
    /// Date when the run was performed
    public let date: Date?
    
    /// When the run was submitted to speedrun.com
    public let submitted: Date?
    
    /// Run completion times in various formats
    public let times: RunTimes
    
    /// Platform/system information
    public let system: RunSystem
    
    /// Link to detailed splits data
    public let splits: RunSplits?
    
    /// Variable values for this run (variable ID -> value ID)
    public let values: [String: String]
    
    /// Related API resources
    public let links: [Link]?
    
    /// Embed types supported for runs
    public enum Embed: String, CaseIterable {
        case game
        case category
        case level
        case players
        case region
        case platform
    }
    
    public typealias EmbedType = Embed
}

/// Video information for a run
public struct RunVideos: Codable, Sendable, Equatable {
    /// Raw video field text if it contains non-link content
    public let text: String?
    
    /// Parsed video URLs
    public let links: [VideoLink]?
}

/// Video link
public struct VideoLink: Codable, Sendable, Equatable {
    /// Video URL
    public let uri: String
}

/// Run verification status
public struct RunStatus: Codable, Sendable, Equatable {
    /// Current verification status
    public let status: Status
    
    /// User ID of the moderator who verified/rejected
    public let examiner: String?
    
    /// When the run was verified
    public let verifyDate: Date?
    
    /// Rejection reason (only present for rejected runs)
    public let reason: String?
    
    /// Status values
    public enum Status: String, Codable, Sendable {
        case new
        case verified
        case rejected
    }
    
    private enum CodingKeys: String, CodingKey {
        case status
        case examiner
        case verifyDate = "verify-date"
        case reason
    }
}

/// Player information for a run
public struct RunPlayer: Codable, Sendable, Equatable {
    /// Whether this is a registered user or guest
    public let rel: PlayerRelation
    
    /// User ID (for registered users)
    public let id: String?
    
    /// Guest name (for guests)
    public let name: String?
    
    /// API URL for this player
    public let uri: String?
    
    /// Player relation type
    public enum PlayerRelation: String, Codable, Sendable {
        case user
        case guest
    }
}

/// Run times in various formats
public struct RunTimes: Codable, Sendable, Equatable {
    /// Primary time (ISO 8601 duration) used for ranking
    public let primary: String
    
    /// Primary time in seconds
    public let primaryT: Double
    
    /// Real-world time (ISO 8601 duration)
    public let realtime: String?
    
    /// Real-world time in seconds
    public let realtimeT: Double
    
    /// Real-world time without loads (ISO 8601 duration)
    public let realtimeNoloads: String?
    
    /// Real-world time without loads in seconds
    public let realtimeNoloadsT: Double
    
    /// In-game time (ISO 8601 duration)
    public let ingame: String?
    
    /// In-game time in seconds
    public let ingameT: Double
    
    private enum CodingKeys: String, CodingKey {
        case primary
        case primaryT = "primary_t"
        case realtime
        case realtimeT = "realtime_t"
        case realtimeNoloads = "realtime_noloads"
        case realtimeNoloadsT = "realtime_noloads_t"
        case ingame
        case ingameT = "ingame_t"
    }
}

/// Platform/system information for a run
public struct RunSystem: Codable, Sendable, Equatable {
    /// Platform ID
    public let platform: String?
    
    /// Whether the run was done on emulator
    public let emulated: Bool
    
    /// Region ID
    public let region: String?
}

/// Splits information
public struct RunSplits: Codable, Sendable, Equatable {
    /// Splits provider (e.g., 'splits.io')
    public let rel: String
    
    /// URL to the splits
    public let uri: String
}