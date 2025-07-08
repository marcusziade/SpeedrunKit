import Foundation
import SpeedrunKit

struct SeriesCommand: Command {
    let name = "series"
    let description = "Browse game series"
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
            try await listSeries(args: subArgs, options: options)
        case "get":
            try await getSeries(args: subArgs, options: options)
        case "games":
            try await getSeriesGames(args: subArgs, options: options)
        case "--help", "-h":
            printHelp()
        default:
            throw CLIError.unknownCommand("series \(subcommand)")
        }
    }
    
    private func printHelp() {
        print("""
        speedrun-cli series - Browse game series
        
        USAGE:
            speedrun-cli series <subcommand> [options]
        
        SUBCOMMANDS:
            list        List all series
            get         Get series details
            games       List games in a series
        
        OPTIONS:
            --max <number>      Maximum results (default: 20)
            --offset <number>   Pagination offset
        
        EXAMPLES:
            speedrun-cli series list
            speedrun-cli series get mario
            speedrun-cli series games mario --max 50
        """)
    }
    
    private func listSeries(args: [String], options: GlobalOptions) async throws {
        var max = 20
        var offset = 0
        
        // Parse options
        var i = 0
        while i < args.count {
            switch args[i] {
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
        let query = SeriesQuery(max: max, offset: offset)
        
        // Fetch series
        let response = try await client.series.list(query: query, embeds: nil)
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(response, format: .json)
            
        case .csv:
            print("id,name,abbreviation,weblink")
            for series in response.data {
                print("\"\(series.id)\",\"\(series.names.international)\",\"\(series.abbreviation)\",\"\(series.weblink)\"")
            }
            
        case .table:
            let headers = ["ID", "Name", "Abbreviation"]
            let rows = response.data.map { series in
                [series.id, series.names.international, series.abbreviation]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
            
            if !options.quiet {
                print("\nShowing \(response.data.count) series (offset: \(offset))")
            }
        }
    }
    
    private func getSeries(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("series ID or abbreviation")
        }
        
        let seriesId = args[0]
        
        // Fetch series
        let series = try await client.series.get(seriesId, embeds: nil)
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(series, format: .json)
            
        case .csv, .table:
            print("Series: \(series.names.international)")
            print("ID: \(series.id)")
            print("Abbreviation: \(series.abbreviation)")
            print("Weblink: \(series.weblink)")
            
            if let created = series.created {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                print("Created: \(formatter.string(from: created))")
            }
            
            if let moderators = series.moderators, !moderators.isEmpty {
                print("\nModerators:")
                for (userId, role) in moderators {
                    print("  - \(userId): \(role.rawValue)")
                }
            }
        }
    }
    
    private func getSeriesGames(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("series ID or abbreviation")
        }
        
        let seriesId = args[0]
        var max = 20
        var offset = 0
        
        // Parse options
        var i = 1
        while i < args.count {
            switch args[i] {
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
        
        // Create pagination
        let pagination = PaginationParameters(max: max, offset: offset)
        
        // Fetch games
        let response = try await client.series.games(
            seriesId: seriesId,
            pagination: pagination
        )
        
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
            let headers = ["ID", "Name", "Released"]
            let rows = response.data.map { game in
                [
                    game.id,
                    game.names.international,
                    game.releaseDate != nil ? "Yes" : "No"
                ]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
            
            if !options.quiet {
                print("\nShowing \(response.data.count) games (offset: \(offset))")
            }
        }
    }
}