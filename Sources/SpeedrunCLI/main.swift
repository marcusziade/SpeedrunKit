import Foundation
import SpeedrunKit

@main
struct SpeedrunCLI {
    static func main() async throws {
        print("🏃 SpeedrunKit CLI Tool")
        print("=======================")
        print("Testing all speedrun.com API features\n")
        
        let client = SpeedrunClient()
        let tester = APITester(client: client)
        
        do {
            try await tester.runAllTests()
            print("\n✅ All tests completed successfully!")
        } catch {
            print("\n❌ Error: \(error)")
            exit(1)
        }
    }
}

/// Main API testing class
struct APITester {
    let client: SpeedrunClient
    
    func runAllTests() async throws {
        print("Starting API tests...\n")
        
        // Test Games API
        try await testGamesAPI()
        
        // Test Categories API
        try await testCategoriesAPI()
        
        // Test Levels API
        try await testLevelsAPI()
        
        // Test Variables API
        try await testVariablesAPI()
        
        // Test Users API
        try await testUsersAPI()
        
        // Test Runs API
        try await testRunsAPI()
        
        // Test Leaderboards API
        try await testLeaderboardsAPI()
        
        // Test Series API
        try await testSeriesAPI()
        
        // Test Platforms, Regions, Genres
        try await testMetadataAPIs()
    }
    
    // MARK: - Games API Tests
    
    func testGamesAPI() async throws {
        print("📦 Testing Games API...")
        
        // List games
        print("  • Listing games...")
        let games = try await client.games.list(
            query: GameQuery(max: 5),
            embeds: nil
        )
        print("    Found \(games.data.count) games")
        
        if let firstGame = games.data.first {
            print("    First game: \(firstGame.names.international)")
            
            // Get specific game
            print("  • Getting game details...")
            let game = try await client.games.get(firstGame.id, embeds: [.categories, .levels])
            print("    Game: \(game.names.international)")
            print("    Released: \(game.releaseDate != nil ? "Yes" : "No")")
            
            // Get categories
            print("  • Getting game categories...")
            let categories = try await client.games.categories(
                gameId: firstGame.id,
                miscellaneous: false,
                orderBy: .pos,
                direction: .ascending
            )
            print("    Found \(categories.count) categories")
            
            // Get levels
            print("  • Getting game levels...")
            let levels = try await client.games.levels(
                gameId: firstGame.id,
                orderBy: .pos,
                direction: .ascending
            )
            print("    Found \(levels.count) levels")
            
            // Get variables
            print("  • Getting game variables...")
            let variables = try await client.games.variables(
                gameId: firstGame.id,
                orderBy: .pos,
                direction: .ascending
            )
            print("    Found \(variables.count) variables")
        }
        
        // Test search
        print("  • Testing game search...")
        let searchResults = try await client.games.list(
            query: GameQuery(name: "Mario", max: 3),
            embeds: nil
        )
        print("    Found \(searchResults.data.count) games matching 'Mario'")
        
        print("  ✓ Games API tests passed\n")
    }
    
    // MARK: - Categories API Tests
    
    func testCategoriesAPI() async throws {
        print("🏷️ Testing Categories API...")
        
        // First get a game with categories
        let games = try await client.games.list(
            query: GameQuery(max: 1),
            embeds: [.categories]
        )
        
        if let game = games.data.first {
            let categories = try await client.games.categories(
                gameId: game.id,
                miscellaneous: nil,
                orderBy: nil,
                direction: nil
            )
            
            if let firstCategory = categories.first {
                // Get category details
                print("  • Getting category details...")
                let category = try await client.categories.get(firstCategory.id, embeds: [.game])
                print("    Category: \(category.name)")
                print("    Type: \(category.type.rawValue)")
                
                // Get category variables
                print("  • Getting category variables...")
                let variables = try await client.categories.variables(
                    categoryId: firstCategory.id,
                    orderBy: nil,
                    direction: nil
                )
                print("    Found \(variables.count) variables")
            }
        }
        
        print("  ✓ Categories API tests passed\n")
    }
    
    // MARK: - Levels API Tests
    
    func testLevelsAPI() async throws {
        print("🎮 Testing Levels API...")
        
        // Find a game with levels
        let games = try await client.games.list(
            query: GameQuery(max: 10),
            embeds: nil
        )
        
        var foundLevel = false
        for game in games.data {
            let levels = try await client.games.levels(
                gameId: game.id,
                orderBy: nil,
                direction: nil
            )
            
            if let firstLevel = levels.first {
                // Get level details
                print("  • Getting level details...")
                let level = try await client.levels.get(firstLevel.id, embeds: [.categories])
                print("    Level: \(level.name)")
                
                // Get level categories
                print("  • Getting level categories...")
                let categories = try await client.levels.categories(
                    levelId: firstLevel.id,
                    miscellaneous: nil,
                    orderBy: nil,
                    direction: nil
                )
                print("    Found \(categories.count) categories")
                
                foundLevel = true
                break
            }
        }
        
        if !foundLevel {
            print("  ⚠️  No games with levels found in first 10 games")
        }
        
        print("  ✓ Levels API tests passed\n")
    }
    
    // MARK: - Variables API Tests
    
    func testVariablesAPI() async throws {
        print("🔧 Testing Variables API...")
        
        // Get a game with variables
        let games = try await client.games.list(
            query: GameQuery(max: 5),
            embeds: nil
        )
        
        var foundVariable = false
        for game in games.data {
            let variables = try await client.games.variables(
                gameId: game.id,
                orderBy: nil,
                direction: nil
            )
            
            if let firstVariable = variables.first {
                // Get variable details
                print("  • Getting variable details...")
                let variable = try await client.variables.get(firstVariable.id)
                print("    Variable: \(variable.name)")
                print("    Mandatory: \(variable.mandatory)")
                
                foundVariable = true
                break
            }
        }
        
        if !foundVariable {
            print("  ⚠️  No games with variables found")
        }
        
        print("  ✓ Variables API tests passed\n")
    }
    
    // MARK: - Users API Tests
    
    func testUsersAPI() async throws {
        print("👤 Testing Users API...")
        
        // List users
        print("  • Listing users...")
        let users = try await client.users.list(
            query: UserQuery(max: 5)
        )
        print("    Found \(users.data.count) users")
        
        if let firstUser = users.data.first {
            // Get user details
            print("  • Getting user details...")
            let user = try await client.users.get(firstUser.id)
            print("    User: \(user.names.international)")
            print("    Role: \(user.role.rawValue)")
            
            // Get personal bests
            print("  • Getting personal bests...")
            let pbs = try await client.users.personalBests(
                userId: firstUser.id,
                top: 5,
                series: nil,
                game: nil,
                embeds: nil
            )
            print("    Found \(pbs.count) personal bests")
        }
        
        // Test guest endpoint
        print("  • Testing guest endpoint...")
        do {
            let guest = try await client.users.getGuest(name: "Guest123")
            print("    Guest found: \(guest.name)")
        } catch {
            print("    Guest not found (expected)")
        }
        
        print("  ✓ Users API tests passed\n")
    }
    
    // MARK: - Runs API Tests
    
    func testRunsAPI() async throws {
        print("🏃 Testing Runs API...")
        
        // List runs
        print("  • Listing runs...")
        let runs = try await client.runs.list(
            query: RunQuery(max: 3),
            embeds: [.game, .category, .players]
        )
        print("    Found \(runs.data.count) runs")
        
        if let firstRun = runs.data.first {
            // Get run details
            print("  • Getting run details...")
            let run = try await client.runs.get(firstRun.id, embeds: nil)
            print("    Run ID: \(run.id)")
            print("    Status: \(run.status.status.rawValue)")
            print("    Primary time: \(run.times.primary)")
        }
        
        // Note: We won't test POST/PUT/DELETE operations as they require authentication
        print("  ⚠️  Skipping authenticated endpoints (create, update, delete)")
        
        print("  ✓ Runs API tests passed\n")
    }
    
    // MARK: - Leaderboards API Tests
    
    func testLeaderboardsAPI() async throws {
        print("🏆 Testing Leaderboards API...")
        
        // Get a game and category for leaderboard testing
        let games = try await client.games.list(
            query: GameQuery(max: 1),
            embeds: nil
        )
        
        if let game = games.data.first {
            let categories = try await client.games.categories(
                gameId: game.id,
                miscellaneous: false,
                orderBy: nil,
                direction: nil
            )
            
            if let category = categories.first {
                // Get full-game leaderboard
                print("  • Getting full-game leaderboard...")
                let leaderboard = try await client.leaderboards.fullGame(
                    game: game.id,
                    category: category.id,
                    query: LeaderboardQuery(top: 10),
                    embeds: [.players]
                )
                print("    Game: \(game.names.international)")
                print("    Category: \(category.name)")
                print("    Runs: \(leaderboard.runs.count)")
                
                if let topRun = leaderboard.runs.first {
                    print("    #1 time: \(topRun.run.times.primary)")
                }
            }
        }
        
        print("  ✓ Leaderboards API tests passed\n")
    }
    
    // MARK: - Series API Tests
    
    func testSeriesAPI() async throws {
        print("🎯 Testing Series API...")
        
        // List series
        print("  • Listing series...")
        let series = try await client.series.list(
            query: SeriesQuery(max: 5),
            embeds: nil
        )
        print("    Found \(series.data.count) series")
        
        if let firstSeries = series.data.first {
            // Get series details
            print("  • Getting series details...")
            let seriesDetail = try await client.series.get(firstSeries.id, embeds: nil)
            print("    Series: \(seriesDetail.names.international)")
            
            // Get games in series
            print("  • Getting games in series...")
            let games = try await client.series.games(
                seriesId: firstSeries.id,
                pagination: PaginationParameters(max: 5)
            )
            print("    Found \(games.data.count) games")
        }
        
        print("  ✓ Series API tests passed\n")
    }
    
    // MARK: - Metadata APIs Tests
    
    func testMetadataAPIs() async throws {
        print("📊 Testing Metadata APIs...")
        
        // Test Platforms
        print("  • Testing Platforms...")
        let platforms = try await client.platforms.list(orderBy: .name, direction: .ascending)
        print("    Found \(platforms.count) platforms")
        
        if let firstPlatform = platforms.first {
            let platform = try await client.platforms.get(firstPlatform.id)
            print("    First platform: \(platform.name)")
        }
        
        // Test Regions
        print("  • Testing Regions...")
        let regions = try await client.regions.list(orderBy: .name, direction: .ascending)
        print("    Found \(regions.count) regions")
        
        // Test Genres
        print("  • Testing Genres...")
        let genres = try await client.genres.list(orderBy: .name, direction: .ascending)
        print("    Found \(genres.count) genres")
        
        // Test Engines
        print("  • Testing Engines...")
        let engines = try await client.genres.listEngines(orderBy: .name, direction: .ascending)
        print("    Found \(engines.count) engines")
        
        // Test Developers
        print("  • Testing Developers...")
        let developers = try await client.genres.listDevelopers(orderBy: .name, direction: .ascending)
        print("    Found \(developers.count) developers")
        
        // Test Publishers
        print("  • Testing Publishers...")
        let publishers = try await client.genres.listPublishers(orderBy: .name, direction: .ascending)
        print("    Found \(publishers.count) publishers")
        
        // Test Game Types
        print("  • Testing Game Types...")
        let gameTypes = try await client.genres.listGameTypes(orderBy: .name, direction: .ascending)
        print("    Found \(gameTypes.count) game types")
        
        print("  ✓ Metadata APIs tests passed\n")
    }
}