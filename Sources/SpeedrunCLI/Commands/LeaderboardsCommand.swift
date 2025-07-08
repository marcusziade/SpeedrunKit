import Foundation
import SpeedrunKit

struct LeaderboardsCommand: Command {
    let name = "leaderboards"
    let description = "View game and level leaderboards"
    let client: SpeedrunClient
    
    func execute(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            printHelp()
            return
        }
        
        let subcommand = args[0]
        let subArgs = Array(args.dropFirst())
        
        switch subcommand {
        case "game":
            try await getGameLeaderboard(args: subArgs, options: options)
        case "level":
            try await getLevelLeaderboard(args: subArgs, options: options)
        case "--help", "-h":
            printHelp()
        default:
            throw CLIError.unknownCommand("leaderboards \(subcommand)")
        }
    }
    
    private func printHelp() {
        print("""
        speedrun-cli leaderboards - View game and level leaderboards
        
        USAGE:
            speedrun-cli leaderboards <subcommand> [options]
        
        SUBCOMMANDS:
            game <game-id> <category-id>    View full-game leaderboard
            level <game-id> <level-id> <category-id>    View level leaderboard
        
        OPTIONS:
            --top <number>       Number of places to show
            --platform <id>      Filter by platform
            --region <id>        Filter by region
            --emulator <bool>    Include/exclude emulator runs
            --video-only         Only runs with video
        
        EXAMPLES:
            speedrun-cli leaderboards game sm64 120star --top 10
            speedrun-cli leaderboards level sm64 bob 70star --video-only
        """)
    }
    
    private func getGameLeaderboard(args: [String], options: GlobalOptions) async throws {
        guard args.count >= 2 else {
            throw CLIError.missingArgument("game ID and category ID required")
        }
        
        let gameId = args[0]
        let categoryId = args[1]
        var top = 10
        var platform: String?
        var region: String?
        var emulators: Bool?
        var videoOnly = false
        
        // Parse options
        var i = 2
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
                
            case "--platform":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--platform value")
                }
                platform = args[i]
                
            case "--region":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--region value")
                }
                region = args[i]
                
            case "--emulator":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--emulator value")
                }
                switch args[i].lowercased() {
                case "true", "yes", "only":
                    emulators = true
                case "false", "no", "exclude":
                    emulators = false
                default:
                    throw CLIError.invalidArgument("--emulator", "must be true/false")
                }
                
            case "--video-only":
                videoOnly = true
                
            default:
                throw CLIError.unknownCommand(args[i])
            }
            i += 1
        }
        
        // Create query
        let query = LeaderboardQuery(
            top: top,
            platform: platform,
            region: region,
            emulators: emulators,
            videoOnly: videoOnly
        )
        
        // Fetch leaderboard
        let leaderboard = try await client.leaderboards.fullGame(
            game: gameId,
            category: categoryId,
            query: query,
            embeds: nil
        )
        
        // Format output
        formatLeaderboard(leaderboard, options: options)
    }
    
    private func getLevelLeaderboard(args: [String], options: GlobalOptions) async throws {
        guard args.count >= 3 else {
            throw CLIError.missingArgument("game ID, level ID, and category ID required")
        }
        
        let gameId = args[0]
        let levelId = args[1]
        let categoryId = args[2]
        var top = 10
        var platform: String?
        var region: String?
        var emulators: Bool?
        var videoOnly = false
        
        // Parse options
        var i = 3
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
                
            case "--platform":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--platform value")
                }
                platform = args[i]
                
            case "--region":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--region value")
                }
                region = args[i]
                
            case "--emulator":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--emulator value")
                }
                switch args[i].lowercased() {
                case "true", "yes", "only":
                    emulators = true
                case "false", "no", "exclude":
                    emulators = false
                default:
                    throw CLIError.invalidArgument("--emulator", "must be true/false")
                }
                
            case "--video-only":
                videoOnly = true
                
            default:
                throw CLIError.unknownCommand(args[i])
            }
            i += 1
        }
        
        // Create query
        let query = LeaderboardQuery(
            top: top,
            platform: platform,
            region: region,
            emulators: emulators,
            videoOnly: videoOnly
        )
        
        // Fetch leaderboard
        let leaderboard = try await client.leaderboards.level(
            game: gameId,
            level: levelId,
            category: categoryId,
            query: query,
            embeds: nil
        )
        
        // Format output
        formatLeaderboard(leaderboard, options: options)
    }
    
    private func formatLeaderboard(_ leaderboard: Leaderboard, options: GlobalOptions) {
        switch options.format {
        case .json:
            do {
                try OutputFormatter.format(leaderboard, format: .json)
            } catch {
                print("Error formatting JSON: \(error)")
            }
            
        case .csv:
            print("place,player,time,date,comment")
            for entry in leaderboard.runs {
                let playerName = entry.run.players.first?.name ?? "Unknown"
                let date = entry.run.date != nil ? ISO8601DateFormatter().string(from: entry.run.date!) : "N/A"
                let comment = entry.run.comment ?? ""
                print("\"\(entry.place)\",\"\(playerName)\",\"\(entry.run.times.primary)\",\"\(date)\",\"\(comment)\"")
            }
            
        case .table:
            // Print header info
            if let game = leaderboard.embeddedGame {
                print("Game: \(game.names.international)")
            }
            if let category = leaderboard.embeddedCategory {
                print("Category: \(category.name)")
            }
            if let level = leaderboard.embeddedLevel {
                print("Level: \(level.name)")
            }
            print("")
            
            if leaderboard.runs.isEmpty {
                print("No runs found")
            } else {
                let headers = ["Place", "Player", "Time", "Date"]
                let rows = leaderboard.runs.map { entry in
                    let playerName = entry.run.players.first?.name ?? "Unknown"
                    let date: String
                    if let runDate = entry.run.date {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        date = formatter.string(from: runDate)
                    } else {
                        date = "N/A"
                    }
                    
                    return [
                        "#\(entry.place)",
                        playerName,
                        formatTime(entry.run.times.primary),
                        date
                    ]
                }
                OutputFormatter.printTable(headers: headers, rows: rows)
            }
        }
    }
    
    private func formatTime(_ time: String) -> String {
        // Try to format PT1H23M45S format to something more readable
        if time.starts(with: "PT") {
            let formatted = String(time.dropFirst(2)) // Remove PT
                .replacingOccurrences(of: "H", with: "h ")
                .replacingOccurrences(of: "M", with: "m ")
                .replacingOccurrences(of: "S", with: "s")
            return formatted
        }
        return time
    }
}

// Extension to help with embeds
extension Leaderboard {
    var embeddedGame: Game? {
        // This would need proper implementation based on how embeds work
        // For now, returning nil
        return nil
    }
    
    var embeddedCategory: Category? {
        return nil
    }
    
    var embeddedLevel: Level? {
        return nil
    }
}