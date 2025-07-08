import Foundation

/// Platforms API operations
public protocol PlatformsAPI: APISection {
    /// List all platforms
    /// - Parameters:
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of platforms
    func list(orderBy: PlatformOrderBy?, direction: SortDirection?) async throws -> [Platform]
    
    /// Get a specific platform
    /// - Parameter id: Platform ID
    /// - Returns: The requested platform
    func get(_ id: String) async throws -> Platform
}

/// Sort fields for platforms
public enum PlatformOrderBy: String, Encodable {
    case name
    case released
}

/// Implementation of PlatformsAPI
struct PlatformsAPIImpl: PlatformsAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func list(orderBy: PlatformOrderBy?, direction: SortDirection?) async throws -> [Platform] {
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Platform]> = try await network.get(
            "/platforms",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func get(_ id: String) async throws -> Platform {
        let response: SingleResourceResponse<Platform> = try await network.get("/platforms/\(id)", queryItems: nil)
        return response.data
    }
}