import Foundation

/// Custom variable to distinguish between runs (e.g., difficulty, character)
public struct Variable: ResourceProtocol {
    /// Unique identifier for the variable
    public let id: String
    
    /// Variable name
    public let name: String
    
    /// Category ID if this variable only applies to a specific category
    public let category: String?
    
    /// Defines where this variable applies
    public let scope: VariableScope
    
    /// Whether a value must be provided for new submissions
    public let mandatory: Bool
    
    /// Whether users can provide custom values
    public let userDefined: Bool
    
    /// Whether different values create separate leaderboards
    public let obsoletes: Bool
    
    /// Possible values for this variable
    public let values: VariableValues
    
    /// Whether this variable should be displayed as a subcategory
    public let isSubcategory: Bool
    
    /// Related API resources
    public let links: [Link]?
    
    /// No embeds supported for variables
    public typealias EmbedType = NoEmbed
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case scope
        case mandatory
        case userDefined = "user-defined"
        case obsoletes
        case values
        case isSubcategory = "is-subcategory"
        case links
    }
}

/// Defines where a variable applies
public struct VariableScope: Codable, Sendable, Equatable {
    /// Scope of the variable application
    public let type: ScopeType
    
    /// Level ID when type is single-level
    public let level: String?
    
    /// Variable scope types
    public enum ScopeType: String, Codable, Sendable {
        case global
        case fullGame = "full-game"
        case allLevels = "all-levels"
        case singleLevel = "single-level"
    }
}

/// Possible values for a variable
public struct VariableValues: Codable, Sendable, Equatable {
    /// Map of value IDs to value details
    public let values: [String: VariableValue]
    
    /// Default value ID
    public let `default`: String?
}

/// Individual variable value
public struct VariableValue: Codable, Sendable, Equatable {
    /// Display name for this value
    public let label: String
    
    /// Rules specific to this value (for subcategories)
    public let rules: String?
    
    /// Flags for this value
    public let flags: VariableFlags?
}

/// Flags for variable values
public struct VariableFlags: Codable, Sendable, Equatable {
    /// Whether this value represents a misc subcategory
    public let miscellaneous: Bool?
}