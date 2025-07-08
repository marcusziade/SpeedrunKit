import Foundation
import SpeedrunKit

struct GamesCommand: Command {
    let name = "games"
    let description = "Manage and search games"
    let client: SpeedrunClient
    
    func execute(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            printHelp()
            return
        }
        
        let subcommand = args[0]
        let subArgs = Array(args.dropFirst())
        
        switch subcommand {
        case "list":
            try await listGames(args: subArgs, options: options)
        case "get":
            try await getGame(args: subArgs, options: options)
        case "categories":
            try await getCategories(args: subArgs, options: options)
        case "levels":
            try await getLevels(args: subArgs, options: options)
        case "variables":
            try await getVariables(args: subArgs, options: options)
        case "records":
            try await getRecords(args: subArgs, options: options)
        case "--help", "-h":
            printHelp()
        default:
            throw CLIError.unknownCommand("games \(subcommand)")
        }
    }
    
    private func printHelp() {
        print("""
        speedrun-cli games - Manage and search games
        
        USAGE:
            speedrun-cli games <subcommand> [options]
        
        SUBCOMMANDS:
            list         List games with optional search/filter
            get          Get details for a specific game
            categories   List categories for a game
            levels       List levels for a game
            variables    List variables for a game
            records      Get records for a game
        
        EXAMPLES:
            speedrun-cli games list --search "Mario"
            speedrun-cli games get sm64
            speedrun-cli games categories sm64
        """)
    }
    
    private func listGames(args: [String], options: GlobalOptions) async throws {
        var search: String?
        var year: Int?
        var platform: String?
        var genre: String?
        var max = 20
        var offset = 0
        
        // Parse arguments
        var i = 0
        while i < args.count {
            switch args[i] {
            case "--search":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--search value")
                }
                search = args[i]
                
            case "--year":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--year value")
                }
                guard let y = Int(args[i]) else {
                    throw CLIError.invalidArgument("--year", "must be a number")
                }
                year = y
                
            case "--platform":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--platform value")
                }
                platform = args[i]
                
            case "--genre":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--genre value")
                }
                genre = args[i]
                
            case "--max":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--max value")
                }
                guard let m = Int(args[i]), m > 0, m <= 200 else {
                    throw CLIError.invalidArgument("--max", "must be 1-200")
                }
                max = m
                
            case "--offset":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--offset value")
                }
                guard let o = Int(args[i]), o >= 0 else {
                    throw CLIError.invalidArgument("--offset", "must be >= 0")
                }
                offset = o
                
            default:
                throw CLIError.unknownCommand(args[i])
            }
            i += 1
        }
        
        // Create query
        let query = GameQuery(
            name: search,
            released: year,
            platform: platform,
            genre: genre,
            max: max,
            offset: offset
        )
        
        // Fetch games
        let response = try await client.games.list(query: query, embeds: nil)
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(response, format: .json)
            
        case .csv:
            print("id,name,abbreviation,released,weblink")
            for game in response.data {
                let released = game.releaseDate != nil ? "Yes" : "No"
                print("\"\(game.id)\",\"\(game.names.international)\",\"\(game.abbreviation)\",\"\(released)\",\"\(game.weblink)\"")
            }
            
        case .table:
            let headers = ["ID", "Name", "Abbreviation", "Released"]
            let rows = response.data.map { game in
                [
                    game.id,
                    game.names.international,
                    game.abbreviation,
                    game.releaseDate != nil ? "Yes" : "No"
                ]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
            
            if !options.quiet {
                print("\nShowing \(response.data.count) games (offset: \(offset))")
            }
        }
    }
    
    private func getGame(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("game ID or abbreviation")
        }
        
        let gameId = args[0]
        var embeds: [Game.Embed] = []
        
        // Parse embed options
        var i = 1
        while i < args.count {
            switch args[i] {
            case "--embed":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--embed value")
                }
                let embedStr = args[i]
                guard let embed = Game.Embed(rawValue: embedStr) else {
                    throw CLIError.invalidArgument("--embed", "invalid embed type: \(embedStr)")
                }
                embeds.append(embed)
                
            default:
                throw CLIError.unknownCommand(args[i])
            }
            i += 1
        }
        
        // Fetch game
        let game = try await client.games.get(gameId, embeds: embeds.isEmpty ? nil : embeds)
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(game, format: .json)
            
        case .csv, .table:
            print("Game: \(game.names.international)")
            print("ID: \(game.id)")
            print("Abbreviation: \(game.abbreviation)")
            if let date = game.releaseDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                print("Release Date: \(formatter.string(from: date))")
            }
            print("Platforms: \(game.platforms.joined(separator: ", "))")
            print("Weblink: \(game.weblink)")
            
            if !game.moderators.isEmpty {
                print("\nModerators:")
                for (userId, role) in game.moderators {
                    print("  - \(userId): \(role.rawValue)")
                }
            }
        }
    }
    
    private func getCategories(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("game ID or abbreviation")
        }
        
        let gameId = args[0]
        var miscellaneous: Bool?
        
        // Parse options
        var i = 1
        while i < args.count {
            switch args[i] {
            case "--miscellaneous":
                miscellaneous = true
            case "--no-miscellaneous":
                miscellaneous = false
            default:
                throw CLIError.unknownCommand(args[i])
            }
            i += 1
        }
        
        // Fetch categories
        let categories = try await client.games.categories(
            gameId: gameId,
            miscellaneous: miscellaneous,
            orderBy: .pos,
            direction: .ascending
        )
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(categories, format: .json)
            
        case .csv:
            print("id,name,type,miscellaneous,weblink")
            for category in categories {
                print("\"\(category.id)\",\"\(category.name)\",\"\(category.type.rawValue)\",\"\(category.miscellaneous)\",\"\(category.weblink)\"")
            }
            
        case .table:
            let headers = ["ID", "Name", "Type", "Misc"]
            let rows = categories.map { category in
                [
                    category.id,
                    category.name,
                    category.type.rawValue,
                    category.miscellaneous ? "Yes" : "No"
                ]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
        }
    }
    
    private func getLevels(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("game ID or abbreviation")
        }
        
        let gameId = args[0]
        
        // Fetch levels
        let levels = try await client.games.levels(
            gameId: gameId,
            orderBy: .pos,
            direction: .ascending
        )
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(levels, format: .json)
            
        case .csv:
            print("id,name,weblink")
            for level in levels {
                print("\"\(level.id)\",\"\(level.name)\",\"\(level.weblink)\"")
            }
            
        case .table:
            let headers = ["ID", "Name"]
            let rows = levels.map { level in
                [level.id, level.name]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
        }
    }
    
    private func getVariables(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("game ID or abbreviation")
        }
        
        let gameId = args[0]
        
        // Fetch variables
        let variables = try await client.games.variables(
            gameId: gameId,
            orderBy: .pos,
            direction: .ascending
        )
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(variables, format: .json)
            
        case .csv:
            print("id,name,category,scope,mandatory")
            for variable in variables {
                let scope = variable.scope.type
                print("\"\(variable.id)\",\"\(variable.name)\",\"\(variable.category ?? "N/A")\",\"\(scope)\",\"\(variable.mandatory)\"")
            }
            
        case .table:
            let headers = ["ID", "Name", "Scope", "Mandatory"]
            let rows = variables.map { variable in
                [
                    variable.id,
                    variable.name,
                    variable.scope.type.rawValue,
                    variable.mandatory ? "Yes" : "No"
                ]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
        }
    }
    
    private func getRecords(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("game ID or abbreviation")
        }
        
        let gameId = args[0]
        var top = 3
        var skipEmpty = true
        
        // Parse options
        var i = 1
        while i < args.count {
            switch args[i] {
            case "--top":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--top value")
                }
                guard let t = Int(args[i]), t > 0 else {
                    throw CLIError.invalidArgument("--top", "must be > 0")
                }
                top = t
                
            case "--include-empty":
                skipEmpty = false
                
            default:
                throw CLIError.unknownCommand(args[i])
            }
            i += 1
        }
        
        // Fetch records
        let records = try await client.games.records(
            gameId: gameId,
            top: top,
            scope: .fullGame,
            miscellaneous: true,
            skipEmpty: skipEmpty,
            pagination: nil
        )
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(records, format: .json)
            
        case .csv, .table:
            for record in records.data {
                print("\n=== Category: \(record.category) ===")
                if record.runs.isEmpty {
                    print("No runs")
                } else {
                    let headers = ["Place", "Player", "Time"]
                    let rows = record.runs.map { run in
                        let playerName = run.run.players.first?.name ?? "Unknown"
                        return [
                            "\(run.place)",
                            playerName,
                            run.run.times.primary
                        ]
                    }
                    OutputFormatter.printTable(headers: headers, rows: rows)
                }
            }
        }
    }
}