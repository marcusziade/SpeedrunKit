import Foundation

/// Protocol defining the networking requirements for the Speedrun API client
public protocol NetworkProtocol: Sendable {
    /// Performs a GET request to the specified endpoint
    /// - Parameters:
    ///   - endpoint: The API endpoint to request
    ///   - queryItems: Optional query parameters
    /// - Returns: The decoded response of type T
    func get<T: Decodable>(_ endpoint: String, queryItems: [URLQueryItem]?) async throws -> T
    
    /// Performs a POST request to the specified endpoint
    /// - Parameters:
    ///   - endpoint: The API endpoint to request
    ///   - body: The request body to encode
    /// - Returns: The decoded response of type T
    func post<T: Decodable, U: Encodable>(_ endpoint: String, body: U) async throws -> T
    
    /// Performs a PUT request to the specified endpoint
    /// - Parameters:
    ///   - endpoint: The API endpoint to request
    ///   - body: The request body to encode
    /// - Returns: The decoded response of type T
    func put<T: Decodable, U: Encodable>(_ endpoint: String, body: U) async throws -> T
    
    /// Performs a DELETE request to the specified endpoint
    /// - Parameters:
    ///   - endpoint: The API endpoint to request
    /// - Returns: The decoded response of type T
    func delete<T: Decodable>(_ endpoint: String) async throws -> T
}