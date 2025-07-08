import Foundation

/// Levels API operations
public protocol LevelsAPI: APISection {
    /// Get a level
    /// - Parameters:
    ///   - id: Level ID
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: The requested level
    func get(_ id: String, embeds: [Level.Embed]?) async throws -> Level
    
    /// Get categories for a level
    /// - Parameters:
    ///   - levelId: Level ID
    ///   - miscellaneous: Filter miscellaneous categories
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of categories
    func categories(
        levelId: String,
        miscellaneous: Bool?,
        orderBy: CategoryOrderBy?,
        direction: SortDirection?
    ) async throws -> [Category]
    
    /// Get variables for a level
    /// - Parameters:
    ///   - levelId: Level ID
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of variables
    func variables(
        levelId: String,
        orderBy: VariableOrderBy?,
        direction: SortDirection?
    ) async throws -> [Variable]
    
    /// Get records for a level
    /// - Parameters:
    ///   - levelId: Level ID
    ///   - top: Number of top places to return
    ///   - skipEmpty: Skip empty leaderboards
    ///   - pagination: Pagination parameters
    /// - Returns: Paginated list of leaderboards
    func records(
        levelId: String,
        top: Int?,
        skipEmpty: Bool?,
        pagination: PaginationParameters?
    ) async throws -> PaginatedData<Leaderboard>
}

/// Implementation of LevelsAPI
struct LevelsAPIImpl: LevelsAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func get(_ id: String, embeds: [Level.Embed]?) async throws -> Level {
        var queryItems: [URLQueryItem] = []
        
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        let response: SingleResourceResponse<Level> = try await network.get(
            "/levels/\(id)",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func categories(
        levelId: String,
        miscellaneous: Bool?,
        orderBy: CategoryOrderBy?,
        direction: SortDirection?
    ) async throws -> [Category] {
        var queryItems: [URLQueryItem] = []
        
        if let miscellaneous = miscellaneous {
            queryItems.append(URLQueryItem(name: "miscellaneous", value: String(miscellaneous)))
        }
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Category]> = try await network.get(
            "/levels/\(levelId)/categories",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func variables(
        levelId: String,
        orderBy: VariableOrderBy?,
        direction: SortDirection?
    ) async throws -> [Variable] {
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Variable]> = try await network.get(
            "/levels/\(levelId)/variables",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func records(
        levelId: String,
        top: Int?,
        skipEmpty: Bool?,
        pagination: PaginationParameters?
    ) async throws -> PaginatedData<Leaderboard> {
        var queryItems: [URLQueryItem] = []
        
        if let top = top {
            queryItems.append(URLQueryItem(name: "top", value: String(top)))
        }
        
        if let skipEmpty = skipEmpty {
            queryItems.append(URLQueryItem(name: "skip-empty", value: String(skipEmpty)))
        }
        
        if let pagination = pagination {
            queryItems.append(contentsOf: pagination.toURLQueryItems())
        }
        
        return try await network.get(
            "/levels/\(levelId)/records",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
    }
}