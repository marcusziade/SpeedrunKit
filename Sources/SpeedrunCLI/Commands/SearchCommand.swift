import Foundation
import SpeedrunKit

struct SearchCommand: Command {
    let name = "search"
    let description = "Search across games, users, and series"
    let client: SpeedrunClient
    
    func execute(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            printHelp()
            return
        }
        
        if args[0] == "--help" || args[0] == "-h" {
            printHelp()
            return
        }
        
        // First argument is the search query
        let query = args[0]
        var searchType = "all"
        var max = 10
        
        // Parse options
        var i = 1
        while i < args.count {
            switch args[i] {
            case "--type":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--type value")
                }
                searchType = args[i]
                
            case "--max":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--max value")
                }
                guard let m = Int(args[i]), m > 0, m <= 200 else {
                    throw CLIError.invalidArgument("--max", "must be 1-200")
                }
                max = m
                
            default:
                throw CLIError.unknownCommand(args[i])
            }
            i += 1
        }
        
        // Perform searches based on type
        switch searchType.lowercased() {
        case "games":
            try await searchGames(query: query, max: max, options: options)
            
        case "users":
            try await searchUsers(query: query, max: max, options: options)
            
        case "series":
            try await searchSeries(query: query, max: max, options: options)
            
        case "all":
            if options.format == .json {
                // For JSON, we need to create a combined result
                print("{")
                print("  \"games\": ")
                try await searchGames(query: query, max: max, options: options)
                print(",")
                print("  \"users\": ")
                try await searchUsers(query: query, max: max, options: options)
                print(",")
                print("  \"series\": ")
                try await searchSeries(query: query, max: max, options: options)
                print("}")
            } else {
                print("=== GAMES ===")
                try await searchGames(query: query, max: max, options: options)
                print("\n=== USERS ===")
                try await searchUsers(query: query, max: max, options: options)
                print("\n=== SERIES ===")
                try await searchSeries(query: query, max: max, options: options)
            }
            
        default:
            throw CLIError.invalidArgument("--type", "must be games, users, series, or all")
        }
    }
    
    private func printHelp() {
        print("""
        speedrun-cli search - Search across games, users, and series
        
        USAGE:
            speedrun-cli search <query> [options]
        
        OPTIONS:
            --type <type>    Type: games, users, series, all (default: all)
            --max <number>   Maximum results per type (default: 10)
        
        EXAMPLES:
            speedrun-cli search "Mario"
            speedrun-cli search "Mario" --type games
            speedrun-cli search "cheese" --type users --max 5
        """)
    }
    
    private func searchGames(query: String, max: Int, options: GlobalOptions) async throws {
        let gameQuery = GameQuery(name: query, max: max)
        let response = try await client.games.list(query: gameQuery, embeds: nil)
        
        switch options.format {
        case .json:
            try OutputFormatter.format(response.data, format: .json)
            
        case .csv:
            print("id,name,abbreviation,released")
            for game in response.data {
                let released = game.releaseDate != nil ? "Yes" : "No"
                print("\"\(game.id)\",\"\(game.names.international)\",\"\(game.abbreviation)\",\"\(released)\"")
            }
            
        case .table:
            if response.data.isEmpty {
                print("No games found")
            } else {
                let headers = ["ID", "Name", "Released"]
                let rows = response.data.map { game in
                    [
                        game.id,
                        game.names.international,
                        game.releaseDate != nil ? "Yes" : "No"
                    ]
                }
                OutputFormatter.printTable(headers: headers, rows: rows)
            }
        }
    }
    
    private func searchUsers(query: String, max: Int, options: GlobalOptions) async throws {
        let userQuery = UserQuery(name: query, max: max)
        let response = try await client.users.list(query: userQuery)
        
        switch options.format {
        case .json:
            try OutputFormatter.format(response.data, format: .json)
            
        case .csv:
            print("id,name,role")
            for user in response.data {
                print("\"\(user.id)\",\"\(user.names.international)\",\"\(user.role.rawValue)\"")
            }
            
        case .table:
            if response.data.isEmpty {
                print("No users found")
            } else {
                let headers = ["ID", "Name", "Role"]
                let rows = response.data.map { user in
                    [user.id, user.names.international, user.role.rawValue]
                }
                OutputFormatter.printTable(headers: headers, rows: rows)
            }
        }
    }
    
    private func searchSeries(query: String, max: Int, options: GlobalOptions) async throws {
        // Series doesn't have a name search parameter, so we'll need to fetch all and filter
        let seriesQuery = SeriesQuery(max: 200) // Get more to filter
        let response = try await client.series.list(query: seriesQuery, embeds: nil)
        
        // Filter by name
        let filtered = response.data.filter { series in
            series.names.international.lowercased().contains(query.lowercased()) ||
            series.abbreviation.lowercased().contains(query.lowercased())
        }.prefix(max)
        
        switch options.format {
        case .json:
            try OutputFormatter.format(Array(filtered), format: .json)
            
        case .csv:
            print("id,name,abbreviation")
            for series in filtered {
                print("\"\(series.id)\",\"\(series.names.international)\",\"\(series.abbreviation)\"")
            }
            
        case .table:
            if filtered.isEmpty {
                print("No series found")
            } else {
                let headers = ["ID", "Name", "Abbreviation"]
                let rows = filtered.map { series in
                    [series.id, series.names.international, series.abbreviation]
                }
                OutputFormatter.printTable(headers: headers, rows: rows)
            }
        }
    }
}