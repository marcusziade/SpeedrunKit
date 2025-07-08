import Foundation

/// Regions API operations
public protocol RegionsAPI: APISection {
    /// List all regions
    /// - Parameters:
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of regions
    func list(orderBy: RegionOrderBy?, direction: SortDirection?) async throws -> [Region]
    
    /// Get a specific region
    /// - Parameter id: Region ID
    /// - Returns: The requested region
    func get(_ id: String) async throws -> Region
}

/// Sort fields for regions
public enum RegionOrderBy: String, Encodable {
    case name
}

/// Implementation of RegionsAPI
struct RegionsAPIImpl: RegionsAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func list(orderBy: RegionOrderBy?, direction: SortDirection?) async throws -> [Region] {
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Region]> = try await network.get(
            "/regions",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
    
    func get(_ id: String) async throws -> Region {
        let response: SingleResourceResponse<Region> = try await network.get("/regions/\(id)", queryItems: nil)
        return response.data
    }
}