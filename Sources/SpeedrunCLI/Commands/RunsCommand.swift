import Foundation
import SpeedrunKit

struct RunsCommand: Command {
    let name = "runs"
    let description = "Manage speedrun submissions"
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
            try await listRuns(args: subArgs, options: options)
        case "get":
            try await getRun(args: subArgs, options: options)
        case "--help", "-h":
            printHelp()
        default:
            throw CLIError.unknownCommand("runs \(subcommand)")
        }
    }
    
    private func printHelp() {
        print("""
        speedrun-cli runs - Manage speedrun submissions
        
        USAGE:
            speedrun-cli runs <subcommand> [options]
        
        SUBCOMMANDS:
            list    List recent runs
            get     Get run details
        
        LIST OPTIONS:
            --game <id>         Filter by game
            --user <username>   Filter by user
            --guest <name>      Filter by guest name
            --status <status>   Filter by status (new, verified, rejected)
            --max <number>      Maximum results (default: 20)
            --offset <number>   Pagination offset
        
        EXAMPLES:
            speedrun-cli runs list --game sm64 --status verified
            speedrun-cli runs get abc123
        """)
    }
    
    private func listRuns(args: [String], options: GlobalOptions) async throws {
        var game: String?
        var user: String?
        var guest: String?
        var status: RunStatus.Status?
        var max = 20
        var offset = 0
        
        // Parse options
        var i = 0
        while i < args.count {
            switch args[i] {
            case "--game":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--game value")
                }
                game = args[i]
                
            case "--user":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--user value")
                }
                user = args[i]
                
            case "--guest":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--guest value")
                }
                guest = args[i]
                
            case "--status":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--status value")
                }
                guard let s = RunStatus.Status(rawValue: args[i]) else {
                    throw CLIError.invalidArgument("--status", "must be new, verified, or rejected")
                }
                status = s
                
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
        let query = RunQuery(
            user: user,
            guest: guest,
            game: game,
            status: status,
            max: max,
            offset: offset
        )
        
        // Fetch runs
        let response = try await client.runs.list(query: query, embeds: nil)
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(response, format: .json)
            
        case .csv:
            print("id,game,category,player,time,status,date")
            for run in response.data {
                let playerName = run.players.first?.name ?? "Unknown"
                let date = run.date != nil ? ISO8601DateFormatter().string(from: run.date!) : "N/A"
                print("\"\(run.id)\",\"\(run.game)\",\"\(run.category)\",\"\(playerName)\",\"\(run.times.primary)\",\"\(run.status.status.rawValue)\",\"\(date)\"")
            }
            
        case .table:
            let headers = ["ID", "Game", "Player", "Time", "Status"]
            let rows = response.data.map { run in
                [
                    run.id,
                    run.game,
                    run.players.first?.name ?? "Unknown",
                    formatTime(run.times.primary),
                    run.status.status.rawValue
                ]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
            
            if !options.quiet {
                print("\nShowing \(response.data.count) runs (offset: \(offset))")
            }
        }
    }
    
    private func getRun(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("run ID")
        }
        
        let runId = args[0]
        
        // Fetch run
        let run = try await client.runs.get(runId, embeds: nil)
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(run, format: .json)
            
        case .csv, .table:
            print("Run Details")
            print("-----------")
            print("ID: \(run.id)")
            print("Game: \(run.game)")
            print("Category: \(run.category)")
            if let level = run.level {
                print("Level: \(level)")
            }
            print("Status: \(run.status.status.rawValue)")
            
            if let examiner = run.status.examiner {
                print("Examiner: \(examiner)")
            }
            
            print("\nPlayers:")
            for player in run.players {
                print("  - \(player.name ?? "Unknown")")
            }
            
            print("\nTimes:")
            print("  Primary: \(formatTime(run.times.primary))")
            if let realtime = run.times.realtime {
                print("  Real Time: \(formatTime(realtime))")
            }
            if let realtimeNoloads = run.times.realtimeNoloads {
                print("  Real Time (No Loads): \(formatTime(realtimeNoloads))")
            }
            if let ingame = run.times.ingame {
                print("  In-Game: \(formatTime(ingame))")
            }
            
            if let date = run.date {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                print("\nRun Date: \(formatter.string(from: date))")
            }
            
            if let submitted = run.submitted {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                print("Submitted: \(formatter.string(from: submitted))")
            }
            
            if let comment = run.comment {
                print("\nComment: \(comment)")
            }
            
            if let videos = run.videos {
                if let text = videos.text {
                    print("\nVideo: \(text)")
                }
                if let links = videos.links {
                    print("\nVideo Links:")
                    for link in links {
                        print("  - \(link.uri)")
                    }
                }
            }
            
            print("\nWeblink: \(run.weblink)")
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