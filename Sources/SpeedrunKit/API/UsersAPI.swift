import Foundation

/// Users API operations
public protocol UsersAPI: APISection {
    /// List users
    /// - Parameters:
    ///   - query: Optional query parameters for filtering
    /// - Returns: Paginated list of users
    func list(query: UserQuery?) async throws -> PaginatedData<User>
    
    /// Get a specific user
    /// - Parameters:
    ///   - id: User ID or username
    /// - Returns: The requested user
    func get(_ id: String) async throws -> User
    
    /// Get user's personal bests
    /// - Parameters:
    ///   - userId: User ID or username
    ///   - top: Only PBs with this place or better
    ///   - series: Series ID or abbreviation
    ///   - game: Game ID or abbreviation
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: List of personal bests
    func personalBests(
        userId: String,
        top: Int?,
        series: String?,
        game: String?,
        embeds: [PersonalBestEmbed]?
    ) async throws -> [PersonalBest]
    
    /// Get a guest user
    /// - Parameter name: Guest name (case-insensitive)
    /// - Returns: The guest information
    func getGuest(name: String) async throws -> Guest
}

/// Query parameters for listing users
public struct UserQuery: Encodable {
    /// Exact search across names, URLs, and social profiles
    public let lookup: String?
    
    /// Case-insensitive name/URL search
    public let name: String?
    
    /// Twitch username
    public let twitch: String?
    
    /// Hitbox username
    public let hitbox: String?
    
    /// Twitter username
    public let twitter: String?
    
    /// SpeedRunsLive username
    public let speedrunslive: String?
    
    /// Sort field
    public let orderby: UserOrderBy?
    
    /// Sort direction
    public let direction: SortDirection?
    
    /// Pagination parameters
    public let max: Int?
    public let offset: Int?
    
    public init(
        lookup: String? = nil,
        name: String? = nil,
        twitch: String? = nil,
        hitbox: String? = nil,
        twitter: String? = nil,
        speedrunslive: String? = nil,
        orderby: UserOrderBy? = nil,
        direction: SortDirection? = nil,
        max: Int? = nil,
        offset: Int? = nil
    ) {
        self.lookup = lookup
        self.name = name
        self.twitch = twitch
        self.hitbox = hitbox
        self.twitter = twitter
        self.speedrunslive = speedrunslive
        self.orderby = orderby
        self.direction = direction
        self.max = max
        self.offset = offset
    }
}

/// Sort fields for users
public enum UserOrderBy: String, Encodable {
    case nameInternational = "name.int"
    case nameJapanese = "name.jap"
    case signup
    case role
}

/// Embed options for personal bests
public enum PersonalBestEmbed: String {
    case game
    case category
    case level
    case players
    case region
    case platform
}

/// Implementation of UsersAPI
struct UsersAPIImpl: UsersAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func list(query: UserQuery?) async throws -> PaginatedData<User> {
        var queryItems: [URLQueryItem] = []
        
        if let query = query {
            queryItems.append(contentsOf: query.toURLQueryItems())
        }
        
        return try await network.get("/users", queryItems: queryItems.isEmpty ? nil : queryItems)
    }
    
    func get(_ id: String) async throws -> User {
        let response: SingleResourceResponse<User> = try await network.get("/users/\(id)", queryItems: nil)
        return response.data
    }
    
    func personalBests(
        userId: String,
        top: Int?,
        series: String?,
        game: String?,
        embeds: [PersonalBestEmbed]?
    ) async throws -> [PersonalBest] {
        var queryItems: [URLQueryItem] = []
        
        if let top = top {
            queryItems.append(URLQueryItem(name: "top", value: String(top)))
        }
        
        if let series = series {
            queryItems.append(URLQueryItem(name: "series", value: series))
        }
        
        if let game = game {
            queryItems.append(URLQueryItem(name: "game", value: game))
        }
        
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        let response: SingleResourceResponse<[PersonalBest]> = try await network.get(
            "/users/\(userId)/personal-bests",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func getGuest(name: String) async throws -> Guest {
        let response: SingleResourceResponse<Guest> = try await network.get("/guests/\(name)", queryItems: nil)
        return response.data
    }
}