import Foundation

/// A game classification/genre
public struct Genre: ResourceProtocol {
    /// Unique identifier for the genre
    public let id: String
    
    /// Genre name (e.g., 'Action', 'RPG')
    public let name: String
    
    /// Related API resources
    public let links: [Link]?
    
    /// No embeds supported for genres
    public typealias EmbedType = NoEmbed
}