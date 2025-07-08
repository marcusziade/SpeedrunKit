import Foundation

/// Represents an image asset with dimensions
public struct Asset: Codable, Sendable, Equatable {
    /// URL to the asset image
    public let uri: String
    
    /// Width of the image in pixels
    public let width: Int
    
    /// Height of the image in pixels
    public let height: Int
    
    /// Initialize an Asset
    /// - Parameters:
    ///   - uri: URL to the asset image
    ///   - width: Width of the image in pixels
    ///   - height: Height of the image in pixels
    public init(uri: String, width: Int, height: Int) {
        self.uri = uri
        self.width = width
        self.height = height
    }
}