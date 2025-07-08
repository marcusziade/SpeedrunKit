import Foundation

/// Geographic location information
public struct Location: Codable, Sendable, Equatable {
    /// Country information
    public let country: Country?
    
    /// Region/state information within the country
    public let region: LocationRegion?
    
    /// Country information
    public struct Country: Codable, Sendable, Equatable {
        /// ISO Alpha-2 country code
        public let code: String
        
        /// Country names
        public let names: Names
    }
    
    /// Region/state information
    public struct LocationRegion: Codable, Sendable, Equatable {
        /// Custom region code
        public let code: String
        
        /// Region names
        public let names: Names
    }
}