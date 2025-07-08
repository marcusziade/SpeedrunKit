import Foundation

/// A game development studio/person
public struct Developer: ResourceProtocol {
    /// Unique identifier for the developer
    public let id: String
    
    /// Developer name
    public let name: String
    
    /// Related API resources
    public let links: [Link]?
    
    /// No embeds supported for developers
    public typealias EmbedType = NoEmbed
}