import Foundation

/// Wrapper for single resource API responses
public struct SingleResourceResponse<T: Decodable & Sendable>: Decodable, Sendable {
    /// The resource data
    public let data: T
}