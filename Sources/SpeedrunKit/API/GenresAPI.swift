import Foundation

/// Genres API operations
public protocol GenresAPI: APISection {
    /// List all genres
    /// - Parameters:
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of genres
    func list(orderBy: GenreOrderBy?, direction: SortDirection?) async throws -> [Genre]
    
    /// Get a specific genre
    /// - Parameter id: Genre ID
    /// - Returns: The requested genre
    func get(_ id: String) async throws -> Genre
    
    /// List all engines
    /// - Parameters:
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of engines
    func listEngines(orderBy: EngineOrderBy?, direction: SortDirection?) async throws -> [Engine]
    
    /// Get a specific engine
    /// - Parameter id: Engine ID
    /// - Returns: The requested engine
    func getEngine(_ id: String) async throws -> Engine
    
    /// List all developers
    /// - Parameters:
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of developers
    func listDevelopers(orderBy: DeveloperOrderBy?, direction: SortDirection?) async throws -> [Developer]
    
    /// Get a specific developer
    /// - Parameter id: Developer ID
    /// - Returns: The requested developer
    func getDeveloper(_ id: String) async throws -> Developer
    
    /// List all publishers
    /// - Parameters:
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of publishers
    func listPublishers(orderBy: PublisherOrderBy?, direction: SortDirection?) async throws -> [Publisher]
    
    /// Get a specific publisher
    /// - Parameter id: Publisher ID
    /// - Returns: The requested publisher
    func getPublisher(_ id: String) async throws -> Publisher
    
    /// List all game types
    /// - Parameters:
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of game types
    func listGameTypes(orderBy: GameTypeOrderBy?, direction: SortDirection?) async throws -> [GameType]
    
    /// Get a specific game type
    /// - Parameter id: Game type ID
    /// - Returns: The requested game type
    func getGameType(_ id: String) async throws -> GameType
}

/// Sort fields for genres
public enum GenreOrderBy: String, Encodable {
    case name
}

/// Sort fields for engines
public enum EngineOrderBy: String, Encodable {
    case name
}

/// Sort fields for developers
public enum DeveloperOrderBy: String, Encodable {
    case name
}

/// Sort fields for publishers
public enum PublisherOrderBy: String, Encodable {
    case name
}

/// Sort fields for game types
public enum GameTypeOrderBy: String, Encodable {
    case name
}

/// Implementation of GenresAPI
struct GenresAPIImpl: GenresAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func list(orderBy: GenreOrderBy?, direction: SortDirection?) async throws -> [Genre] {
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Genre]> = try await network.get(
            "/genres",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func get(_ id: String) async throws -> Genre {
        let response: SingleResourceResponse<Genre> = try await network.get("/genres/\(id)", queryItems: nil)
        return response.data
    }
    
    func listEngines(orderBy: EngineOrderBy?, direction: SortDirection?) async throws -> [Engine] {
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Engine]> = try await network.get(
            "/engines",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func getEngine(_ id: String) async throws -> Engine {
        let response: SingleResourceResponse<Engine> = try await network.get("/engines/\(id)", queryItems: nil)
        return response.data
    }
    
    func listDevelopers(orderBy: DeveloperOrderBy?, direction: SortDirection?) async throws -> [Developer] {
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Developer]> = try await network.get(
            "/developers",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func getDeveloper(_ id: String) async throws -> Developer {
        let response: SingleResourceResponse<Developer> = try await network.get("/developers/\(id)", queryItems: nil)
        return response.data
    }
    
    func listPublishers(orderBy: PublisherOrderBy?, direction: SortDirection?) async throws -> [Publisher] {
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Publisher]> = try await network.get(
            "/publishers",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func getPublisher(_ id: String) async throws -> Publisher {
        let response: SingleResourceResponse<Publisher> = try await network.get("/publishers/\(id)", queryItems: nil)
        return response.data
    }
    
    func listGameTypes(orderBy: GameTypeOrderBy?, direction: SortDirection?) async throws -> [GameType] {
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[GameType]> = try await network.get(
            "/gametypes",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func getGameType(_ id: String) async throws -> GameType {
        let response: SingleResourceResponse<GameType> = try await network.get("/gametypes/\(id)", queryItems: nil)
        return response.data
    }
}