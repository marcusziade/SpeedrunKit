import Foundation

/// Payload for submitting a new run
public struct RunSubmit: Encodable, Sendable {
    /// Category ID
    public let category: String
    
    /// Level ID (for individual level runs)
    public let level: String?
    
    /// Date when the run was performed (defaults to today)
    public let date: Date?
    
    /// Region ID
    public let region: String?
    
    /// Platform ID (required)
    public let platform: String
    
    /// Auto-verify the run (moderators only)
    public let verified: Bool?
    
    /// At least one time must be provided
    public let times: SubmitTimes
    
    /// Players (defaults to submitting user)
    public let players: [SubmitPlayer]?
    
    /// Whether the run was done on emulator
    public let emulated: Bool?
    
    /// Video URL (may be required by game rules)
    public let video: String?
    
    /// Additional information about the run
    public let comment: String?
    
    /// Splits.io ID or URL
    public let splitsio: String?
    
    /// Variable values for the run
    public let variables: [String: SubmitVariable]?
    
    /// Initialize a run submission
    public init(
        category: String,
        level: String? = nil,
        date: Date? = nil,
        region: String? = nil,
        platform: String,
        verified: Bool? = nil,
        times: SubmitTimes,
        players: [SubmitPlayer]? = nil,
        emulated: Bool? = nil,
        video: String? = nil,
        comment: String? = nil,
        splitsio: String? = nil,
        variables: [String: SubmitVariable]? = nil
    ) {
        self.category = category
        self.level = level
        self.date = date
        self.region = region
        self.platform = platform
        self.verified = verified
        self.times = times
        self.players = players
        self.emulated = emulated
        self.video = video
        self.comment = comment
        self.splitsio = splitsio
        self.variables = variables
    }
}

/// Times for run submission
public struct SubmitTimes: Encodable, Sendable {
    /// Real-world time in seconds
    public let realtime: Double?
    
    /// Real-world time without loads in seconds
    public let realtimeNoloads: Double?
    
    /// In-game time in seconds
    public let ingame: Double?
    
    private enum CodingKeys: String, CodingKey {
        case realtime
        case realtimeNoloads = "realtime_noloads"
        case ingame
    }
    
    /// Initialize with at least one time
    public init(realtime: Double? = nil, realtimeNoloads: Double? = nil, ingame: Double? = nil) {
        guard realtime != nil || realtimeNoloads != nil || ingame != nil else {
            fatalError("At least one time must be provided")
        }
        self.realtime = realtime
        self.realtimeNoloads = realtimeNoloads
        self.ingame = ingame
    }
}

/// Player for run submission
public struct SubmitPlayer: Encodable, Sendable {
    /// Whether this is a registered user or guest
    public let rel: String
    
    /// User ID (for registered users)
    public let id: String?
    
    /// Guest name (for guests)
    public let name: String?
    
    /// Initialize a registered user player
    public static func user(id: String) -> SubmitPlayer {
        SubmitPlayer(rel: "user", id: id, name: nil)
    }
    
    /// Initialize a guest player
    public static func guest(name: String) -> SubmitPlayer {
        SubmitPlayer(rel: "guest", id: nil, name: name)
    }
}

/// Variable value for run submission
public struct SubmitVariable: Encodable, Sendable {
    /// Whether using existing or new value
    public let type: String
    
    /// Value ID (pre-defined) or custom value (user-defined)
    public let value: String
    
    /// Initialize a pre-defined variable value
    public static func predefined(value: String) -> SubmitVariable {
        SubmitVariable(type: "pre-defined", value: value)
    }
    
    /// Initialize a user-defined variable value
    public static func userDefined(value: String) -> SubmitVariable {
        SubmitVariable(type: "user-defined", value: value)
    }
}