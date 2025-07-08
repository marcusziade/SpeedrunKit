import Foundation

/// Color values for different backgrounds
public struct Color: Codable, Sendable, Equatable {
    /// Hex color code for use on light backgrounds
    public let light: String
    
    /// Hex color code for use on dark backgrounds
    public let dark: String
    
    /// Initialize a Color
    /// - Parameters:
    ///   - light: Hex color code for light backgrounds
    ///   - dark: Hex color code for dark backgrounds
    public init(light: String, dark: String) {
        self.light = light
        self.dark = dark
    }
}