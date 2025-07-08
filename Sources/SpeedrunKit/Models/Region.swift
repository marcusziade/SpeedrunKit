import Foundation

/// A geographic region for game releases
public struct Region: ResourceProtocol {
    /// Unique identifier for the region
    public let id: String
    
    /// Region name (e.g., 'USA / NTSC')
    public let name: String
    
    /// Related API resources
    public let links: [Link]?
    
    /// No embeds supported for regions
    public typealias EmbedType = NoEmbed
}