import Foundation

/// A registered speedrun.com user
public struct User: ResourceProtocol {
    /// Unique identifier for the user
    public let id: String
    
    /// Username in different scripts
    public let names: Names
    
    /// URL to the user's profile page
    public let weblink: String
    
    /// How the username should be styled
    public let nameStyle: NameStyle
    
    /// User's role on the site
    public let role: UserRole
    
    /// When the user registered (null for old accounts)
    public let signup: Date?
    
    /// User's location
    public let location: Location?
    
    /// Twitch account link
    public let twitch: SocialLink?
    
    /// Hitbox account link
    public let hitbox: SocialLink?
    
    /// YouTube channel link
    public let youtube: SocialLink?
    
    /// Twitter account link
    public let twitter: SocialLink?
    
    /// SpeedRunsLive profile link
    public let speedrunslive: SocialLink?
    
    /// Related API resources
    public let links: [Link]?
    
    /// Embed types supported for users
    public enum Embed: String, CaseIterable {
        case personalBests = "personal-bests"
    }
    
    public typealias EmbedType = Embed
    
    private enum CodingKeys: String, CodingKey {
        case id
        case names
        case weblink
        case nameStyle = "name-style"
        case role
        case signup
        case location
        case twitch
        case hitbox
        case youtube
        case twitter
        case speedrunslive
        case links
    }
}

/// Username styling information
public struct NameStyle: Codable, Sendable, Equatable {
    /// Color style type
    public let style: Style
    
    /// Color for solid style
    public let color: Color?
    
    /// Start color for gradient style
    public let colorFrom: Color?
    
    /// End color for gradient style
    public let colorTo: Color?
    
    /// Style types
    public enum Style: String, Codable, Sendable {
        case solid
        case gradient
    }
    
    private enum CodingKeys: String, CodingKey {
        case style
        case color
        case colorFrom = "color-from"
        case colorTo = "color-to"
    }
}

/// User roles on the site
public enum UserRole: String, Codable, Sendable {
    case banned
    case user
    case trusted
    case moderator
    case admin
    case programmer
}

/// Social media link
public struct SocialLink: Codable, Sendable, Equatable {
    /// URL to the social media profile
    public let uri: String
}

/// An unregistered runner
public struct Guest: Codable, Sendable {
    /// Guest's display name
    public let name: String
    
    /// Related API resources
    public let links: [Link]?
}