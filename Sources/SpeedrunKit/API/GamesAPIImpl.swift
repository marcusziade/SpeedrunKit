import Foundation

/// Implementation of GamesAPI
struct GamesAPIImpl: GamesAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func list(query: GameQuery?, embeds: [Game.Embed]?) async throws -> PaginatedData<Game> {
        var queryItems: [URLQueryItem] = []
        
        // Add query parameters
        if let query = query {
            queryItems.append(contentsOf: query.toURLQueryItems())
        }
        
        // Add embeds
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        return try await network.get("/games", queryItems: queryItems.isEmpty ? nil : queryItems)
    }
    
    func get(_ id: String, embeds: [Game.Embed]?) async throws -> Game {
        var queryItems: [URLQueryItem] = []
        
        // Add embeds
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        let response: SingleResourceResponse<Game> = try await network.get(
            "/games/\(id)",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func categories(
        gameId: String,
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
            "/games/\(gameId)/categories",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func levels(
        gameId: String,
        orderBy: LevelOrderBy?,
        direction: SortDirection?
    ) async throws -> [Level] {
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Level]> = try await network.get(
            "/games/\(gameId)/levels",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func variables(
        gameId: String,
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
            "/games/\(gameId)/variables",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func derivedGames(gameId: String) async throws -> [Game] {
        let response: SingleResourceResponse<[Game]> = try await network.get(
            "/games/\(gameId)/derived-games",
            queryItems: nil
        )
        return response.data
    }
    
    func records(
        gameId: String,
        top: Int?,
        scope: RecordScope?,
        miscellaneous: Bool?,
        skipEmpty: Bool?,
        pagination: PaginationParameters?
    ) async throws -> PaginatedData<Leaderboard> {
        var queryItems: [URLQueryItem] = []
        
        if let top = top {
            queryItems.append(URLQueryItem(name: "top", value: String(top)))
        }
        
        if let scope = scope {
            queryItems.append(URLQueryItem(name: "scope", value: scope.rawValue))
        }
        
        if let miscellaneous = miscellaneous {
            queryItems.append(URLQueryItem(name: "miscellaneous", value: String(miscellaneous)))
        }
        
        if let skipEmpty = skipEmpty {
            queryItems.append(URLQueryItem(name: "skip-empty", value: String(skipEmpty)))
        }
        
        if let pagination = pagination {
            queryItems.append(contentsOf: pagination.toURLQueryItems())
        }
        
        return try await network.get(
            "/games/\(gameId)/records",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
    }
}

// MARK: - Helper Extensions

extension Encodable {
    func toURLQueryItems() -> [URLQueryItem] {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return []
        }
        
        return json.compactMap { key, value in
            guard let stringValue = value as? String ?? (value as? CustomStringConvertible)?.description else {
                return nil
            }
            return URLQueryItem(name: key, value: stringValue)
        }
    }
}