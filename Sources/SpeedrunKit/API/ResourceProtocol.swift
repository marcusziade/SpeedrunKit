import Foundation

/// Protocol for API resources that can be fetched
public protocol ResourceProtocol: Identifiable, Codable, Sendable where ID == String {
    /// The type used for embedding related resources
    associatedtype EmbedType: RawRepresentable where EmbedType.RawValue == String
    
    /// Links to related resources
    var links: [Link]? { get }
}

/// Default implementation when no embeds are supported
public struct NoEmbed: RawRepresentable, Sendable {
    public let rawValue: String
    
    public init?(rawValue: String) {
        return nil
    }
}

/// Protocol for resources that support pagination
public protocol PaginatableResource: ResourceProtocol {
    /// Query parameters specific to this resource type
    associatedtype QueryParameters: Encodable
}

/// Common query parameters for pagination
public struct PaginationParameters: Encodable, Sendable {
    /// Maximum number of items per page (1-200, default 20)
    public let max: Int?
    
    /// Number of items to skip (for pagination)
    public let offset: Int?
    
    /// Field to sort by
    public let orderby: String?
    
    /// Sort direction
    public let direction: SortDirection?
    
    public init(
        max: Int? = nil,
        offset: Int? = nil,
        orderby: String? = nil,
        direction: SortDirection? = nil
    ) {
        self.max = max
        self.offset = offset
        self.orderby = orderby
        self.direction = direction
    }
}

/// Sort direction for API queries
public enum SortDirection: String, Codable, Sendable {
    case ascending = "asc"
    case descending = "desc"
}