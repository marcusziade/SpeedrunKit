@preconcurrency import Foundation

/// Configuration for the Speedrun API client
public struct SpeedrunConfiguration: Sendable {
    /// The base URL for the API
    public let baseURL: URL
    
    /// Optional API key for authenticated requests
    public let apiKey: String?
    
    /// Timeout interval for requests (in seconds)
    public let timeoutInterval: TimeInterval
    
    /// Maximum number of retries for failed requests
    public let maxRetries: Int
    
    /// Whether to enable debug logging
    public let debugLogging: Bool
    
    /// Default configuration
    public static let `default` = SpeedrunConfiguration(
        baseURL: URL(string: "https://www.speedrun.com/api/v1")!,
        apiKey: nil,
        timeoutInterval: 30,
        maxRetries: 3,
        debugLogging: false
    )
    
    /// Initialize a new configuration
    /// - Parameters:
    ///   - baseURL: The base URL for the API
    ///   - apiKey: Optional API key for authenticated requests
    ///   - timeoutInterval: Timeout interval for requests (default: 30 seconds)
    ///   - maxRetries: Maximum number of retries for failed requests (default: 3)
    ///   - debugLogging: Whether to enable debug logging (default: false)
    public init(
        baseURL: URL = URL(string: "https://www.speedrun.com/api/v1")!,
        apiKey: String? = nil,
        timeoutInterval: TimeInterval = 30,
        maxRetries: Int = 3,
        debugLogging: Bool = false
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.timeoutInterval = timeoutInterval
        self.maxRetries = maxRetries
        self.debugLogging = debugLogging
    }
}