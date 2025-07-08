import Foundation

/// Errors that can occur when using the Speedrun API
public enum SpeedrunError: LocalizedError, Sendable {
    /// Network request failed
    case networkError(Error)
    
    /// Invalid URL or endpoint
    case invalidURL(String)
    
    /// HTTP error with status code
    case httpError(statusCode: Int, message: String?)
    
    /// Failed to decode response
    case decodingError(Error)
    
    /// API returned an error
    case apiError(APIError)
    
    /// Authentication required but no API key provided
    case authenticationRequired
    
    /// Invalid API key
    case invalidAPIKey
    
    /// Rate limit exceeded
    case rateLimitExceeded
    
    /// Unknown error
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .httpError(let statusCode, let message):
            return "HTTP error \(statusCode): \(message ?? "No message")"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .apiError(let error):
            return "API error: \(error.message)"
        case .authenticationRequired:
            return "Authentication required. Please provide an API key."
        case .invalidAPIKey:
            return "Invalid API key"
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}

/// Error response from the API
public struct APIError: Codable, Error, Sendable {
    /// HTTP status code
    public let status: Int
    
    /// Human-readable error message
    public let message: String
    
    /// List of specific validation errors
    public let errors: [String]?
    
    /// Links for support/reporting issues
    public let links: [Link]?
}