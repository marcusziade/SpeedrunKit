import Foundation

/// A game engine/framework
public struct Engine: ResourceProtocol {
    /// Unique identifier for the engine
    public let id: String
    
    /// Engine name (e.g., 'Unity', 'Unreal Engine')
    public let name: String
    
    /// Related API resources
    public let links: [Link]?
    
    /// No embeds supported for engines
    public typealias EmbedType = NoEmbed
}