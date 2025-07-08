import Foundation
import SpeedrunKit

struct UsersCommand: Command {
    let name = "users"
    let description = "Manage users and view profiles"
    let client: SpeedrunClient
    
    func execute(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            printHelp()
            return
        }
        
        let subcommand = args[0]
        let subArgs = Array(args.dropFirst())
        
        switch subcommand {
        case "get":
            try await getUser(args: subArgs, options: options)
        case "pbs":
            try await getPersonalBests(args: subArgs, options: options)
        case "runs":
            try await getUserRuns(args: subArgs, options: options)
        case "search":
            try await searchUsers(args: subArgs, options: options)
        case "--help", "-h":
            printHelp()
        default:
            throw CLIError.unknownCommand("users \(subcommand)")
        }
    }
    
    private func printHelp() {
        print("""
        speedrun-cli users - Manage users and view profiles
        
        USAGE:
            speedrun-cli users <subcommand> [options]
        
        SUBCOMMANDS:
            get <username>    Get user profile
            pbs <username>    Get user's personal bests
            runs <username>   Get user's runs
            search            Search for users
        
        EXAMPLES:
            speedrun-cli users get Cheese
            speedrun-cli users pbs Cheese --top 10
            speedrun-cli users search --name mario
        """)
    }
    
    private func getUser(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("username")
        }
        
        let username = args[0]
        
        // Fetch user
        let user = try await client.users.get(username)
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(user, format: .json)
            
        case .csv, .table:
            print("User: \(user.names.international)")
            print("ID: \(user.id)")
            print("Role: \(user.role.rawValue)")
            print("Weblink: \(user.weblink)")
            
            if let signup = user.signup {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                print("Member Since: \(formatter.string(from: signup))")
            }
            
            if let location = user.location {
                if let country = location.country {
                    print("Country: \(country.names.international)")
                }
                if let region = location.region {
                    print("Region: \(region.names.international)")
                }
            }
            
            if let twitch = user.twitch {
                print("Twitch: https://twitch.tv/\(twitch)")
            }
            
            if let youtube = user.youtube {
                print("YouTube: https://youtube.com/\(youtube)")
            }
        }
    }
    
    private func getPersonalBests(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("username")
        }
        
        let username = args[0]
        var top: Int?
        var series: String?
        var game: String?
        
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
                
            case "--series":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--series value")
                }
                series = args[i]
                
            case "--game":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--game value")
                }
                game = args[i]
                
            default:
                throw CLIError.unknownCommand(args[i])
            }
            i += 1
        }
        
        // Fetch personal bests
        let pbs = try await client.users.personalBests(
            userId: username,
            top: top,
            series: series,
            game: game,
            embeds: nil
        )
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(pbs, format: .json)
            
        case .csv:
            print("place,game,category,time,date")
            for pb in pbs {
                let date = pb.run.date != nil ? ISO8601DateFormatter().string(from: pb.run.date!) : "N/A"
                print("\"\(pb.place)\",\"\(pb.run.game)\",\"\(pb.run.category)\",\"\(pb.run.times.primary)\",\"\(date)\"")
            }
            
        case .table:
            let headers = ["Place", "Game", "Category", "Time"]
            let rows = pbs.map { pb in
                [
                    "#\(pb.place)",
                    pb.run.game,
                    pb.run.category,
                    pb.run.times.primary
                ]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
        }
    }
    
    private func getUserRuns(args: [String], options: GlobalOptions) async throws {
        guard !args.isEmpty else {
            throw CLIError.missingArgument("username")
        }
        
        let username = args[0]
        var game: String?
        var status: RunStatus.Status?
        var max = 20
        var offset = 0
        
        // Parse options
        var i = 1
        while i < args.count {
            switch args[i] {
            case "--game":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--game value")
                }
                game = args[i]
                
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
        
        // Get user first to get their ID
        let user = try await client.users.get(username)
        
        // Create query
        let query = RunQuery(
            user: user.id,
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
            print("id,game,category,time,status,date")
            for run in response.data {
                let date = run.date != nil ? ISO8601DateFormatter().string(from: run.date!) : "N/A"
                print("\"\(run.id)\",\"\(run.game)\",\"\(run.category)\",\"\(run.times.primary)\",\"\(run.status.status.rawValue)\",\"\(date)\"")
            }
            
        case .table:
            let headers = ["Game", "Category", "Time", "Status"]
            let rows = response.data.map { run in
                [
                    run.game,
                    run.category,
                    run.times.primary,
                    run.status.status.rawValue
                ]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
            
            if !options.quiet {
                print("\nShowing \(response.data.count) runs (offset: \(offset))")
            }
        }
    }
    
    private func searchUsers(args: [String], options: GlobalOptions) async throws {
        var name: String?
        var twitch: String?
        var hitbox: String?
        var twitter: String?
        var speedrunslive: String?
        var max = 20
        
        // Parse options
        var i = 0
        while i < args.count {
            switch args[i] {
            case "--name":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--name value")
                }
                name = args[i]
                
            case "--twitch":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--twitch value")
                }
                twitch = args[i]
                
            case "--hitbox":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--hitbox value")
                }
                hitbox = args[i]
                
            case "--twitter":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--twitter value")
                }
                twitter = args[i]
                
            case "--speedrunslive":
                i += 1
                guard i < args.count else {
                    throw CLIError.missingArgument("--speedrunslive value")
                }
                speedrunslive = args[i]
                
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
        
        // Require at least one search parameter
        guard name != nil || twitch != nil || hitbox != nil || twitter != nil || speedrunslive != nil else {
            throw CLIError.missingArgument("at least one search parameter (--name, --twitch, etc.)")
        }
        
        // Create query
        let query = UserQuery(
            name: name,
            twitch: twitch,
            hitbox: hitbox,
            twitter: twitter,
            speedrunslive: speedrunslive,
            max: max
        )
        
        // Search users
        let response = try await client.users.list(query: query)
        
        // Format output
        switch options.format {
        case .json:
            try OutputFormatter.format(response, format: .json)
            
        case .csv:
            print("id,name,role,signup")
            for user in response.data {
                let signup = user.signup != nil ? ISO8601DateFormatter().string(from: user.signup!) : "N/A"
                print("\"\(user.id)\",\"\(user.names.international)\",\"\(user.role.rawValue)\",\"\(signup)\"")
            }
            
        case .table:
            let headers = ["ID", "Name", "Role"]
            let rows = response.data.map { user in
                [user.id, user.names.international, user.role.rawValue]
            }
            OutputFormatter.printTable(headers: headers, rows: rows)
        }
    }
}

