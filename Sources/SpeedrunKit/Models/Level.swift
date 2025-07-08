import Foundation

/// An individual level/stage within a game
public struct Level: ResourceProtocol {
    /// Unique identifier for the level
    public let id: String
    
    /// Level name
    public let name: String
    
    /// URL to the level's page on speedrun.com
    public let weblink: String
    
    /// Level-specific rules
    public let rules: String?
    
    /// Related API resources
    public let links: [Link]?
    
    /// Embed types supported for levels
    public enum Embed: String, CaseIterable {
        case categories
        case variables
    }
    
    public typealias EmbedType = Embed
}