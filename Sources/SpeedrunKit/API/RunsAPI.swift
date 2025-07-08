import Foundation

/// Runs API operations
public protocol RunsAPI: APISection {
    /// List runs
    /// - Parameters:
    ///   - query: Optional query parameters for filtering
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: Paginated list of runs
    func list(query: RunQuery?, embeds: [Run.Embed]?) async throws -> PaginatedData<Run>
    
    /// Get a specific run
    /// - Parameters:
    ///   - id: Run ID
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: The requested run
    func get(_ id: String, embeds: [Run.Embed]?) async throws -> Run
    
    /// Submit a new run (requires authentication)
    /// - Parameter run: The run to submit
    /// - Returns: The created run
    func create(_ run: RunSubmit) async throws -> Run
    
    /// Delete a run (requires authentication)
    /// - Parameter id: Run ID
    /// - Returns: The deleted run
    func delete(_ id: String) async throws -> Run
    
    /// Update run status (requires authentication)
    /// - Parameters:
    ///   - id: Run ID
    ///   - status: New status (verified or rejected)
    ///   - reason: Rejection reason (required when rejecting)
    func updateStatus(_ id: String, status: RunStatus.Status, reason: String?) async throws
    
    /// Update run players (requires authentication)
    /// - Parameters:
    ///   - id: Run ID
    ///   - players: New players list
    /// - Returns: The updated run
    func updatePlayers(_ id: String, players: [SubmitPlayer]) async throws -> Run
}

/// Query parameters for listing runs
public struct RunQuery: Encodable {
    /// User ID
    public let user: String?
    
    /// Guest name
    public let guest: String?
    
    /// Examiner user ID
    public let examiner: String?
    
    /// Game ID
    public let game: String?
    
    /// Level ID
    public let level: String?
    
    /// Category ID
    public let category: String?
    
    /// Platform ID
    public let platform: String?
    
    /// Region ID
    public let region: String?
    
    /// Emulator runs only
    public let emulated: Bool?
    
    /// Run status
    public let status: RunStatus.Status?
    
    /// Sort field
    public let orderby: RunOrderBy?
    
    /// Sort direction
    public let direction: SortDirection?
    
    /// Pagination parameters
    public let max: Int?
    public let offset: Int?
    
    public init(
        user: String? = nil,
        guest: String? = nil,
        examiner: String? = nil,
        game: String? = nil,
        level: String? = nil,
        category: String? = nil,
        platform: String? = nil,
        region: String? = nil,
        emulated: Bool? = nil,
        status: RunStatus.Status? = nil,
        orderby: RunOrderBy? = nil,
        direction: SortDirection? = nil,
        max: Int? = nil,
        offset: Int? = nil
    ) {
        self.user = user
        self.guest = guest
        self.examiner = examiner
        self.game = game
        self.level = level
        self.category = category
        self.platform = platform
        self.region = region
        self.emulated = emulated
        self.status = status
        self.orderby = orderby
        self.direction = direction
        self.max = max
        self.offset = offset
    }
}

/// Sort fields for runs
public enum RunOrderBy: String, Encodable {
    case game
    case category
    case level
    case platform
    case region
    case emulated
    case date
    case submitted
    case status
    case verifyDate = "verify-date"
}

/// Implementation of RunsAPI
struct RunsAPIImpl: RunsAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func list(query: RunQuery?, embeds: [Run.Embed]?) async throws -> PaginatedData<Run> {
        var queryItems: [URLQueryItem] = []
        
        if let query = query {
            queryItems.append(contentsOf: query.toURLQueryItems())
        }
        
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        return try await network.get("/runs", queryItems: queryItems.isEmpty ? nil : queryItems)
    }
    
    func get(_ id: String, embeds: [Run.Embed]?) async throws -> Run {
        var queryItems: [URLQueryItem] = []
        
        if let embeds = embeds, !embeds.isEmpty {
            let embedString = embeds.map { $0.rawValue }.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "embed", value: embedString))
        }
        
        let response: SingleResourceResponse<Run> = try await network.get(
            "/runs/\(id)",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func create(_ run: RunSubmit) async throws -> Run {
        struct RunWrapper: Encodable {
            let run: RunSubmit
        }
        
        let wrapper = RunWrapper(run: run)
        let response: SingleResourceResponse<Run> = try await network.post("/runs", body: wrapper)
        return response.data
    }
    
    func delete(_ id: String) async throws -> Run {
        let response: SingleResourceResponse<Run> = try await network.delete("/runs/\(id)")
        return response.data
    }
    
    func updateStatus(_ id: String, status: RunStatus.Status, reason: String?) async throws {
        struct StatusUpdate: Encodable {
            struct Status: Encodable {
                let status: RunStatus.Status
                let reason: String?
            }
            let status: Status
        }
        
        let update = StatusUpdate(status: StatusUpdate.Status(status: status, reason: reason))
        let _: SingleResourceResponse<EmptyResponse> = try await network.put("/runs/\(id)/status", body: update)
    }
    
    func updatePlayers(_ id: String, players: [SubmitPlayer]) async throws -> Run {
        struct PlayersUpdate: Encodable {
            let players: [SubmitPlayer]
        }
        
        let update = PlayersUpdate(players: players)
        let response: SingleResourceResponse<Run> = try await network.put("/runs/\(id)/players", body: update)
        return response.data
    }
}

/// Empty response for endpoints that don't return data
private struct EmptyResponse: Decodable {}