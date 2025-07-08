import Foundation

/// Protocol for responses that support pagination
public protocol PaginatedResponse {
    associatedtype Item: Decodable
    
    /// The data items in the response
    var data: [Item] { get }
    
    /// Pagination information
    var pagination: Pagination? { get }
}

/// Pagination information from the API
public struct Pagination: Codable, Sendable {
    /// Current offset in the collection
    public let offset: Int
    
    /// Maximum items per page
    public let max: Int
    
    /// Number of items in current page
    public let size: Int
    
    /// Links to next/previous pages
    public let links: [Link]?
}

/// Generic wrapper for paginated API responses
public struct PaginatedData<T: Decodable & Sendable>: Decodable, PaginatedResponse, Sendable {
    public let data: [T]
    public let pagination: Pagination?
    
    public typealias Item = T
}