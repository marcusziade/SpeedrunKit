import Foundation

/// A collection of related games (e.g., Mario, Zelda)
public struct Series: ResourceProtocol {
    /// Unique identifier for the series
    public let id: String
    
    /// Series names in different languages
    public let names: Names
    
    /// Short abbreviation used in URLs
    public let abbreviation: String
    
    /// URL to the series page on speedrun.com
    public let weblink: String
    
    /// Map of user IDs to their moderation roles
    public let moderators: [String: ModeratorRole]?
    
    /// When the series was created (null for old series)
    public let created: Date?
    
    /// Images associated with the series
    public let assets: SeriesAssets
    
    /// Related API resources
    public let links: [Link]?
    
    /// Embed types supported for series
    public enum Embed: String, CaseIterable {
        case moderators
    }
    
    public typealias EmbedType = Embed
}

/// Collection of images associated with a series
public struct SeriesAssets: Codable, Sendable, Equatable {
    /// Series logo
    public let logo: Asset?
    
    /// 32px wide cover image
    public let coverTiny: Asset?
    
    /// 64px wide cover image
    public let coverSmall: Asset?
    
    /// 128px wide cover image
    public let coverMedium: Asset?
    
    /// 256px wide cover image
    public let coverLarge: Asset?
    
    /// Small icon/favicon
    public let icon: Asset?
    
    /// First place trophy icon
    public let trophy1st: Asset?
    
    /// Second place trophy icon
    public let trophy2nd: Asset?
    
    /// Third place trophy icon
    public let trophy3rd: Asset?
    
    /// Fourth place trophy icon (optional)
    public let trophy4th: Asset?
    
    /// Background image for the series page
    public let background: Asset?
    
    /// Foreground image overlay (optional)
    public let foreground: Asset?
    
    private enum CodingKeys: String, CodingKey {
        case logo
        case coverTiny = "cover-tiny"
        case coverSmall = "cover-small"
        case coverMedium = "cover-medium"
        case coverLarge = "cover-large"
        case icon
        case trophy1st = "trophy-1st"
        case trophy2nd = "trophy-2nd"
        case trophy3rd = "trophy-3rd"
        case trophy4th = "trophy-4th"
        case background
        case foreground
    }
}