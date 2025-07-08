import Foundation

/// A system notification for a user
public struct Notification: ResourceProtocol {
    /// Unique identifier for the notification
    public let id: String
    
    /// When the notification was created
    public let created: Date
    
    /// Whether the user has read this notification
    public let status: NotificationStatus
    
    /// Notification message
    public let text: String
    
    /// The item this notification is about
    public let item: NotificationItem
    
    /// Links to related resources (run or game)
    public let links: [Link]?
    
    /// No embeds supported for notifications
    public typealias EmbedType = NoEmbed
}

/// Notification status
public enum NotificationStatus: String, Codable, Sendable {
    case read
    case unread
}

/// The item a notification is about
public struct NotificationItem: Codable, Sendable, Equatable {
    /// Type of item
    public let rel: ItemType
    
    /// Link to the item (may be homepage if item is deleted)
    public let uri: String
    
    /// Item types
    public enum ItemType: String, Codable, Sendable {
        case post
        case run
        case game
        case guide
    }
}