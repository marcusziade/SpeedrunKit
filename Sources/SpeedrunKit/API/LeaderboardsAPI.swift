import Foundation

/// Leaderboards API operations
public protocol LeaderboardsAPI: APISection {
    /// Get full-game leaderboard
    /// - Parameters:
    ///   - game: Game ID or abbreviation
    ///   - category: Category ID or abbreviation
    ///   - query: Optional query parameters for filtering
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: The leaderboard
    func fullGame(
        game: String,
        category: String,
        query: LeaderboardQuery?,
        embeds: [Leaderboard.Embed]?
    ) async throws -> Leaderboard
    
    /// Get individual-level leaderboard
    /// - Parameters:
    ///   - game: Game ID or abbreviation
    ///   - level: Level ID or abbreviation
    ///   - category: Category ID or abbreviation
    ///   - query: Optional query parameters for filtering
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: The leaderboard
    func level(
        game: String,
        level: String,
        category: String,
        query: LeaderboardQuery?,
        embeds: [Leaderboard.Embed]?
    ) async throws -> Leaderboard
}

/// Query parameters for leaderboards
public struct LeaderboardQuery: Encodable {
    /// Number of top places to return
    public let top: Int?
    
    /// Platform ID filter
    public let platform: String?
    
    /// Region ID filter
    public let region: String?
    
    /// Emulator filter
    public let emulators: Bool?
    
    /// Only runs with videos
    public let videoOnly: Bool?
    
    /// Timing method
    public let timing: TimingMethod?
    
    /// Runs before or on this date
    public let date: Date?
    
    /// Variable filters (variable ID -> value ID)
    public let variables: [String: String]?
    
    private enum CodingKeys: String, CodingKey {
        case top, platform, region, emulators
        case videoOnly = "video-only"
        case timing, date
    }
    
    public init(
        top: Int? = nil,
        platform: String? = nil,
        region: String? = nil,
        emulators: Bool? = nil,
        videoOnly: Bool? = nil,
        timing: TimingMethod? = nil,
        date: Date? = nil,
        variables: [String: String]? = nil
    ) {
        self.top = top
        self.platform = platform
        self.region = region
        self.emulators = emulators
        self.videoOnly = videoOnly
        self.timing = timing
        self.date = date
        self.variables = variables
    }
    
    func toURLQueryItems() -> [URLQueryItem] {
        var items = [URLQueryItem]()
        
        if let top = top {
            items.append(URLQueryItem(name: "top", value: String(top)))
        }
        
        if let platform = platform {
            items.append(URLQueryItem(name: "platform", value: platform))
        }
        
        if let region = region {
            items.append(URLQueryItem(name: "region", value: region))
        }
        
        if let emulators = emulators {
            items.append(URLQueryItem(name: "emulators", value: String(emulators)))
        }
        
        if let videoOnly = videoOnly {
            items.append(URLQueryItem(name: "video-only", value: String(videoOnly)))
        }
        
        if let timing = timing {
            items.append(URLQueryItem(name: "timing", value: timing.rawValue))
        }
        
        if let date = date {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            items.append(URLQueryItem(name: "date", value: formatter.string(from: date)))
        }
        
        // Add variable filters
        if let variables = variables {
            for (key, value) in variables {
                items.append(URLQueryItem(name: "var-\(key)", value: value))
            }
        }
        
        return items
    }
}

/// Implementation of LeaderboardsAPI
struct LeaderboardsAPIImpl: LeaderboardsAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func fullGame(
        game: String,
        category: String,
        query: LeaderboardQuery?,
        embeds: [Leaderboard.Embed]?
    ) async throws -> Leaderboard {
        var queryItems: [URLQueryItem] = []
        
        if let query = query {
            queryItems.append(contentsOf: query.toURLQueryItems())
        }
        
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        let response: SingleResourceResponse<Leaderboard> = try await network.get(
            "/leaderboards/\(game)/category/\(category)",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func level(
        game: String,
        level: String,
        category: String,
        query: LeaderboardQuery?,
        embeds: [Leaderboard.Embed]?
    ) async throws -> Leaderboard {
        var queryItems: [URLQueryItem] = []
        
        if let query = query {
            queryItems.append(contentsOf: query.toURLQueryItems())
        }
        
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        let response: SingleResourceResponse<Leaderboard> = try await network.get(
            "/leaderboards/\(game)/level/\(level)/\(category)",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
}