import Foundation

/// A game publishing company
public struct Publisher: ResourceProtocol {
    /// Unique identifier for the publisher
    public let id: String
    
    /// Publisher name
    public let name: String
    
    /// Related API resources
    public let links: [Link]?
    
    /// No embeds supported for publishers
    public typealias EmbedType = NoEmbed
}