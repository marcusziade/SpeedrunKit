import Foundation

/// Games API operations
public protocol GamesAPI: APISection {
    /// List all games
    /// - Parameters:
    ///   - query: Optional query parameters for filtering and pagination
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: Paginated list of games
    func list(query: GameQuery?, embeds: [Game.Embed]?) async throws -> PaginatedData<Game>
    
    /// Get a specific game
    /// - Parameters:
    ///   - id: Game ID or abbreviation
    ///   - embeds: Optional embeds to include in the response
    /// - Returns: The requested game
    func get(_ id: String, embeds: [Game.Embed]?) async throws -> Game
    
    /// Get categories for a game
    /// - Parameters:
    ///   - gameId: Game ID or abbreviation
    ///   - miscellaneous: Filter miscellaneous categories
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of categories
    func categories(
        gameId: String,
        miscellaneous: Bool?,
        orderBy: CategoryOrderBy?,
        direction: SortDirection?
    ) async throws -> [Category]
    
    /// Get levels for a game
    /// - Parameters:
    ///   - gameId: Game ID or abbreviation
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of levels
    func levels(
        gameId: String,
        orderBy: LevelOrderBy?,
        direction: SortDirection?
    ) async throws -> [Level]
    
    /// Get variables for a game
    /// - Parameters:
    ///   - gameId: Game ID or abbreviation
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of variables
    func variables(
        gameId: String,
        orderBy: VariableOrderBy?,
        direction: SortDirection?
    ) async throws -> [Variable]
    
    /// Get derived games
    /// - Parameters:
    ///   - gameId: Game ID or abbreviation
    /// - Returns: List of derived games
    func derivedGames(gameId: String) async throws -> [Game]
    
    /// Get game records
    /// - Parameters:
    ///   - gameId: Game ID or abbreviation
    ///   - top: Number of top places to return
    ///   - scope: Filter by run scope
    ///   - miscellaneous: Include miscellaneous categories
    ///   - skipEmpty: Skip empty leaderboards
    ///   - pagination: Pagination parameters
    /// - Returns: Paginated list of leaderboards
    func records(
        gameId: String,
        top: Int?,
        scope: RecordScope?,
        miscellaneous: Bool?,
        skipEmpty: Bool?,
        pagination: PaginationParameters?
    ) async throws -> PaginatedData<Leaderboard>
}

/// Query parameters for listing games
public struct GameQuery: Encodable {
    /// Fuzzy search across game names and abbreviations
    public let name: String?
    
    /// Exact-match search for this abbreviation
    public let abbreviation: String?
    
    /// Games released in this year
    public let released: Int?
    
    /// Game type ID
    public let gametype: String?
    
    /// Platform ID
    public let platform: String?
    
    /// Region ID
    public let region: String?
    
    /// Genre ID
    public let genre: String?
    
    /// Engine ID
    public let engine: String?
    
    /// Developer ID
    public let developer: String?
    
    /// Publisher ID
    public let publisher: String?
    
    /// Moderator user ID
    public let moderator: String?
    
    /// Enable bulk mode (max 1000 items, no embeds)
    public let bulk: Bool?
    
    /// Sort field
    public let orderby: GameOrderBy?
    
    /// Sort direction
    public let direction: SortDirection?
    
    /// Pagination parameters
    public let max: Int?
    public let offset: Int?
    
    private enum CodingKeys: String, CodingKey {
        case name, abbreviation, released, gametype, platform, region
        case genre, engine, developer, publisher, moderator
        case bulk = "_bulk"
        case orderby, direction, max, offset
    }
    
    public init(
        name: String? = nil,
        abbreviation: String? = nil,
        released: Int? = nil,
        gametype: String? = nil,
        platform: String? = nil,
        region: String? = nil,
        genre: String? = nil,
        engine: String? = nil,
        developer: String? = nil,
        publisher: String? = nil,
        moderator: String? = nil,
        bulk: Bool? = nil,
        orderby: GameOrderBy? = nil,
        direction: SortDirection? = nil,
        max: Int? = nil,
        offset: Int? = nil
    ) {
        self.name = name
        self.abbreviation = abbreviation
        self.released = released
        self.gametype = gametype
        self.platform = platform
        self.region = region
        self.genre = genre
        self.engine = engine
        self.developer = developer
        self.publisher = publisher
        self.moderator = moderator
        self.bulk = bulk
        self.orderby = orderby
        self.direction = direction
        self.max = max
        self.offset = offset
    }
}

/// Sort fields for games
public enum GameOrderBy: String, Encodable {
    case nameInternational = "name.int"
    case nameJapanese = "name.jap"
    case abbreviation
    case released
    case created
    case similarity
}

/// Sort fields for categories
public enum CategoryOrderBy: String, Encodable {
    case name
    case miscellaneous
    case pos
}

/// Sort fields for levels
public enum LevelOrderBy: String, Encodable {
    case name
    case pos
}

/// Sort fields for variables
public enum VariableOrderBy: String, Encodable {
    case name
    case mandatory
    case userDefined = "user-defined"
    case pos
}

/// Record scope filter
public enum RecordScope: String, Encodable {
    case fullGame = "full-game"
    case levels
    case all
}

private enum CodingKeys: String, CodingKey {
    case skipEmpty = "skip-empty"
}