import Foundation

/// Represents an image asset with optional dimensions
public struct Asset: Codable, Sendable, Equatable {
    /// URL to the asset image (can be null if asset doesn't exist)
    public let uri: String?
    
    /// Width of the image in pixels (optional - not always provided by API)
    public let width: Int?
    
    /// Height of the image in pixels (optional - not always provided by API)
    public let height: Int?
    
    /// Initialize an Asset
    /// - Parameters:
    ///   - uri: URL to the asset image (optional)
    ///   - width: Width of the image in pixels (optional)
    ///   - height: Height of the image in pixels (optional)
    public init(uri: String?, width: Int? = nil, height: Int? = nil) {
        self.uri = uri
        self.width = width
        self.height = height
    }
    
    /// Returns true if this asset has a valid URI
    public var isValid: Bool {
        return uri != nil && !uri!.isEmpty
    }
}