import Foundation

/// Represents a hyperlink relationship in the API
public struct Link: Codable, Sendable, Equatable {
    /// The relationship type (e.g., 'self', 'game', 'category', etc.)
    public let rel: String?
    
    /// The full URI to the related resource
    public let uri: String
    
    /// Initialize a new Link
    /// - Parameters:
    ///   - rel: The relationship type
    ///   - uri: The full URI to the related resource
    public init(rel: String? = nil, uri: String) {
        self.rel = rel
        self.uri = uri
    }
}