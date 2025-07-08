import Foundation

/// Internationalized names for resources
public struct Names: Codable, Sendable, Equatable {
    /// The international (typically English) name
    public let international: String
    
    /// The Japanese name, if available
    public let japanese: String?
    
    /// Initialize Names
    /// - Parameters:
    ///   - international: The international name
    ///   - japanese: The Japanese name
    public init(international: String, japanese: String? = nil) {
        self.international = international
        self.japanese = japanese
    }
}