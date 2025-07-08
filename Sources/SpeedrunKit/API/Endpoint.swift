import Foundation

/// Protocol defining an API endpoint
public protocol Endpoint {
    /// The path component of the endpoint
    var path: String { get }
    
    /// The HTTP method for the endpoint
    var method: HTTPMethod { get }
    
    /// Query items for the request
    var queryItems: [URLQueryItem]? { get }
    
    /// Headers for the request
    var headers: [String: String]? { get }
}

/// HTTP methods supported by the API
public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Base implementation for endpoints
public extension Endpoint {
    var queryItems: [URLQueryItem]? { nil }
    var headers: [String: String]? { nil }
}