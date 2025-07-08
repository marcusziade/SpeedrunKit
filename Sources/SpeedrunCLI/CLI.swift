import Foundation
import SpeedrunKit

// MARK: - CLI Infrastructure

enum CLIError: Error, LocalizedError {
    case missingCommand
    case unknownCommand(String)
    case missingArgument(String)
    case invalidArgument(String, String)
    
    var errorDescription: String? {
        switch self {
        case .missingCommand:
            return "No command specified. Run 'speedrun-cli --help' for usage."
        case .unknownCommand(let cmd):
            return "Unknown command: \(cmd)"
        case .missingArgument(let arg):
            return "Missing required argument: \(arg)"
        case .invalidArgument(let arg, let reason):
            return "Invalid argument \(arg): \(reason)"
        }
    }
}

// Output format options
enum OutputFormat: String {
    case table
    case json
    case csv
}

// Global options
struct GlobalOptions {
    var apiKey: String?
    var format: OutputFormat = .table
    var noColor: Bool = false
    var quiet: Bool = false
    var debug: Bool = false
}

// Base protocol for all commands
protocol Command {
    var name: String { get }
    var description: String { get }
    func execute(args: [String], options: GlobalOptions) async throws
}

// Main CLI class
class CLI {
    private let client: SpeedrunClient
    private var commands: [String: Command] = [:]
    private var globalOptions = GlobalOptions()
    
    init() {
        // Initialize client with options from environment or arguments
        let apiKey = ProcessInfo.processInfo.environment["SPEEDRUN_API_KEY"]
        let debug = ProcessInfo.processInfo.environment["SPEEDRUN_DEBUG"]?.lowercased() == "true"
        
        let config = SpeedrunConfiguration(
            apiKey: apiKey,
            debugLogging: debug
        )
        
        self.client = SpeedrunClient(configuration: config)
        
        // Register commands
        registerCommand(HelpCommand(cli: self))
        registerCommand(VersionCommand())
        registerCommand(GamesCommand(client: client))
        registerCommand(UsersCommand(client: client))
        registerCommand(LeaderboardsCommand(client: client))
        registerCommand(RunsCommand(client: client))
        registerCommand(SeriesCommand(client: client))
        registerCommand(SearchCommand(client: client))
        registerCommand(TestCommand(client: client))
    }
    
    func registerCommand(_ command: Command) {
        commands[command.name] = command
    }
    
    func run(arguments: [String]) async throws {
        var args = arguments
        
        // Remove program name
        if !args.isEmpty {
            args.removeFirst()
        }
        
        // Parse global options
        while !args.isEmpty && args[0].starts(with: "--") {
            let arg = args.removeFirst()
            
            switch arg {
            case "--help", "-h":
                try await commands["help"]!.execute(args: [], options: globalOptions)
                return
                
            case "--version", "-v":
                try await commands["version"]!.execute(args: [], options: globalOptions)
                return
                
            case "--api-key":
                guard !args.isEmpty else {
                    throw CLIError.missingArgument("--api-key value")
                }
                globalOptions.apiKey = args.removeFirst()
                
            case "--format":
                guard !args.isEmpty else {
                    throw CLIError.missingArgument("--format value")
                }
                let formatStr = args.removeFirst()
                guard let format = OutputFormat(rawValue: formatStr) else {
                    throw CLIError.invalidArgument("--format", "must be table, json, or csv")
                }
                globalOptions.format = format
                
            case "--no-color":
                globalOptions.noColor = true
                
            case "--quiet":
                globalOptions.quiet = true
                
            case "--debug":
                globalOptions.debug = true
                
            default:
                throw CLIError.unknownCommand(arg)
            }
        }
        
        // Get command
        guard !args.isEmpty else {
            throw CLIError.missingCommand
        }
        
        let commandName = args.removeFirst()
        guard let command = commands[commandName] else {
            throw CLIError.unknownCommand(commandName)
        }
        
        // Execute command
        try await command.execute(args: args, options: globalOptions)
    }
    
    func printHelp() {
        print("""
        speedrun-cli - SpeedrunKit Command Line Interface
        
        USAGE:
            speedrun-cli [global-options] <command> [command-options]
        
        GLOBAL OPTIONS:
            --api-key <key>      API key for authenticated requests
            --format <format>    Output format: table, json, csv (default: table)
            --no-color          Disable colored output
            --quiet             Suppress non-essential output
            --debug             Enable debug logging
            --help, -h          Show help information
            --version, -v       Show version information
        
        COMMANDS:
        """)
        
        let sortedCommands = commands.values.sorted { $0.name < $1.name }
        for command in sortedCommands {
            print("    \(command.name.padding(toLength: 15, withPad: " ", startingAt: 0)) \(command.description)")
        }
        
        print("""
        
        Run 'speedrun-cli <command> --help' for more information on a command.
        """)
    }
}

// MARK: - Basic Commands

struct HelpCommand: Command {
    let name = "help"
    let description = "Show help information"
    let cli: CLI
    
    func execute(args: [String], options: GlobalOptions) async throws {
        cli.printHelp()
    }
}

struct VersionCommand: Command {
    let name = "version"
    let description = "Show version information"
    
    func execute(args: [String], options: GlobalOptions) async throws {
        print("speedrun-cli 1.0.0")
        print("SpeedrunKit SDK for speedrun.com API")
    }
}

// Test command that runs the original test suite
struct TestCommand: Command {
    let name = "test"
    let description = "Run SDK test suite"
    let client: SpeedrunClient
    
    func execute(args: [String], options: GlobalOptions) async throws {
        print("🏃 Running SpeedrunKit Test Suite")
        print("=================================\n")
        
        let tester = APITester(client: client)
        try await tester.runAllTests()
        
        print("\n✅ All tests completed successfully!")
    }
}

// MARK: - Output Formatting

struct OutputFormatter {
    static func format<T: Encodable>(_ data: T, format: OutputFormat, quiet: Bool = false) throws {
        switch format {
        case .json:
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(data)
            print(String(data: jsonData, encoding: .utf8)!)
            
        case .csv:
            // For CSV, we need custom handling per type
            print("CSV output not yet implemented")
            
        case .table:
            // For table, we need custom handling per type
            print("Table output not yet implemented")
        }
    }
    
    static func printTable(headers: [String], rows: [[String]]) {
        guard !rows.isEmpty else {
            print("No data found")
            return
        }
        
        // Calculate column widths
        var widths = headers.map { $0.count }
        for row in rows {
            for (i, cell) in row.enumerated() {
                if i < widths.count {
                    widths[i] = max(widths[i], cell.count)
                }
            }
        }
        
        // Print headers
        let headerRow = headers.enumerated().map { i, header in
            header.padding(toLength: widths[i], withPad: " ", startingAt: 0)
        }.joined(separator: " | ")
        
        print(headerRow)
        print(String(repeating: "-", count: headerRow.count))
        
        // Print rows
        for row in rows {
            let rowStr = row.enumerated().map { i, cell in
                if i < widths.count {
                    return cell.padding(toLength: widths[i], withPad: " ", startingAt: 0)
                }
                return cell
            }.joined(separator: " | ")
            print(rowStr)
        }
    }
}