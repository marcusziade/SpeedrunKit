import Foundation

/// A gaming platform/console
public struct Platform: ResourceProtocol {
    /// Unique identifier for the platform
    public let id: String
    
    /// Platform name (e.g., 'Nintendo Entertainment System')
    public let name: String
    
    /// Year the platform was released
    public let released: Int
    
    /// Related API resources
    public let links: [Link]?
    
    /// No embeds supported for platforms
    public typealias EmbedType = NoEmbed
}