import Foundation

/// Series API operations
public protocol SeriesAPI: APISection {
    /// List series
    /// - Parameters:
    ///   - query: Optional query parameters for filtering
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: Paginated list of series
    func list(query: SeriesQuery?, embeds: [Series.Embed]?) async throws -> PaginatedData<Series>
    
    /// Get a specific series
    /// - Parameters:
    ///   - id: Series ID or abbreviation
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: The requested series
    func get(_ id: String, embeds: [Series.Embed]?) async throws -> Series
    
    /// Get games in a series
    /// - Parameters:
    ///   - seriesId: Series ID or abbreviation
    ///   - pagination: Pagination parameters
    /// - Returns: Paginated list of games
    func games(seriesId: String, pagination: PaginationParameters?) async throws -> PaginatedData<Game>
}

/// Query parameters for listing series
public struct SeriesQuery: Encodable {
    /// Fuzzy search across names and abbreviations
    public let name: String?
    
    /// Exact-match abbreviation search
    public let abbreviation: String?
    
    /// Moderator user ID
    public let moderator: String?
    
    /// Sort field
    public let orderby: SeriesOrderBy?
    
    /// Sort direction
    public let direction: SortDirection?
    
    /// Pagination parameters
    public let max: Int?
    public let offset: Int?
    
    public init(
        name: String? = nil,
        abbreviation: String? = nil,
        moderator: String? = nil,
        orderby: SeriesOrderBy? = nil,
        direction: SortDirection? = nil,
        max: Int? = nil,
        offset: Int? = nil
    ) {
        self.name = name
        self.abbreviation = abbreviation
        self.moderator = moderator
        self.orderby = orderby
        self.direction = direction
        self.max = max
        self.offset = offset
    }
}

/// Sort fields for series
public enum SeriesOrderBy: String, Encodable {
    case nameInternational = "name.int"
    case nameJapanese = "name.jap"
    case abbreviation
    case created
}

/// Implementation of SeriesAPI
struct SeriesAPIImpl: SeriesAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func list(query: SeriesQuery?, embeds: [Series.Embed]?) async throws -> PaginatedData<Series> {
        var queryItems: [URLQueryItem] = []
        
        if let query = query {
            queryItems.append(contentsOf: query.toURLQueryItems())
        }
        
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        return try await network.get("/series", queryItems: queryItems.isEmpty ? nil : queryItems)
    }
    
    func get(_ id: String, embeds: [Series.Embed]?) async throws -> Series {
        var queryItems: [URLQueryItem] = []
        
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        let response: SingleResourceResponse<Series> = try await network.get(
            "/series/\(id)",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func games(seriesId: String, pagination: PaginationParameters?) async throws -> PaginatedData<Game> {
        var queryItems: [URLQueryItem] = []
        
        if let pagination = pagination {
            queryItems.append(contentsOf: pagination.toURLQueryItems())
        }
        
        return try await network.get(
            "/series/\(seriesId)/games",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
    }
}