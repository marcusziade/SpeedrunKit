import Foundation

/// Classification for unofficial games
public struct GameType: ResourceProtocol {
    /// Unique identifier for the game type
    public let id: String
    
    /// Type name (e.g., 'ROM Hack', 'Fangame')
    public let name: String
    
    /// Related API resources
    public let links: [Link]?
    
    /// No embeds supported for game types
    public typealias EmbedType = NoEmbed
}