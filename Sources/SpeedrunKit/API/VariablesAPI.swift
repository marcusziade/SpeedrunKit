import Foundation

/// Variables API operations
public protocol VariablesAPI: APISection {
    /// Get a variable
    /// - Parameters:
    ///   - id: Variable ID
    /// - Returns: The requested variable
    func get(_ id: String) async throws -> Variable
}

/// Implementation of VariablesAPI
struct VariablesAPIImpl: VariablesAPI {
    let network: NetworkProtocol
    let configuration: SpeedrunConfiguration
    
    func get(_ id: String) async throws -> Variable {
        let response: SingleResourceResponse<Variable> = try await network.get(
            "/variables/\(id)",
            queryItems: nil
        )
        return response.data
    }
}