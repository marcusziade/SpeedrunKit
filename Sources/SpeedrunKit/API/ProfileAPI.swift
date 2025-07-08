import Foundation

/// Profile API operations (requires authentication)
public protocol ProfileAPI: APISection {
    /// Get authenticated user profile
    /// - Returns: The authenticated user's profile
    func getProfile() async throws -> User
    
    /// Get user notifications
    /// - Parameters:
    ///   - orderBy: Sort field
    ///   - direction: Sort direction
    /// - Returns: List of notifications
    func getNotifications(orderBy: NotificationOrderBy?, direction: SortDirection?) async throws -> [Notification]
}

/// Sort fields for notifications
public enum NotificationOrderBy: String, Encodable {
    case created
}

/// Implementation of ProfileAPI
struct ProfileAPIImpl: ProfileAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func getProfile() async throws -> User {
        guard configuration.apiKey != nil else {
            throw SpeedrunError.authenticationRequired
        }
        
        let response: SingleResourceResponse<User> = try await network.get("/profile", queryItems: nil)
        return response.data
    }
    
    func getNotifications(orderBy: NotificationOrderBy?, direction: SortDirection?) async throws -> [Notification] {
        guard configuration.apiKey != nil else {
            throw SpeedrunError.authenticationRequired
        }
        
        var queryItems: [URLQueryItem] = []
        
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "orderby", value: orderBy.rawValue))
        }
        
        if let direction = direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        let response: SingleResourceResponse<[Notification]> = try await network.get(
            "/notifications",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        return response.data
    }
}