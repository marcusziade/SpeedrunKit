import Foundation

/// Categories API operations
public protocol CategoriesAPI: APISection {
    /// Get a category
    /// - Parameters:
    ///   - id: Category ID
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: The requested category
    func get(_ id: String, embeds: [Category.Embed]?) async throws -> Category
    
    /// Get variables for a category
    /// - Parameters:
    ///   - categoryId: Category ID
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of variables
    func variables(
        categoryId: String,
        orderBy: VariableOrderBy?,
        direction: SortDirection?
    ) async throws -> [Variable]
    
    /// Get records for a category
    /// - Parameters:
    ///   - categoryId: Category ID
    ///   - top: Number of top places to return
    ///   - skipEmpty: Skip empty leaderboards
    ///   - pagination: Pagination parameters
    /// - Returns: Paginated list of leaderboards
    func records(
        categoryId: String,
        top: Int?,
        skipEmpty: Bool?,
        pagination: PaginationParameters?
    ) async throws -> PaginatedData<Leaderboard>
}

/// Implementation of CategoriesAPI
struct CategoriesAPIImpl: CategoriesAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func get(_ id: String, embeds: [Category.Embed]?) async throws -> Category {
        var queryItems: [URLQueryItem] = []
        
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        let response: SingleResourceResponse<Category> = try await network.get(
            "/categories/\(id)",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func variables(
        categoryId: String,
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
            "/categories/\(categoryId)/variables",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func records(
        categoryId: String,
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
            "/categories/\(categoryId)/records",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
    }
}