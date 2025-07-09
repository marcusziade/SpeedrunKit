@preconcurrency import Foundation
#if canImport(FoundationNetworking)
@preconcurrency import FoundationNetworking
#endif

// MARK: - Platform-specific URLSession async support
#if canImport(FoundationNetworking)
// Linux doesn't have async URLSession methods in Swift 5.9
extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}
#endif

/// URLSession-based implementation of NetworkProtocol
public final class URLSessionNetwork: NetworkProtocol {
    private let configuration: SpeedrunConfiguration
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    /// Initialize URLSessionNetwork
    /// - Parameter configuration: The API configuration
    public init(configuration: SpeedrunConfiguration) {
        self.configuration = configuration
        
        // Configure URLSession
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = configuration.timeoutInterval
        sessionConfig.httpAdditionalHeaders = [
            "Accept": "application/json",
            "User-Agent": "SpeedrunKit/1.0"
        ]
        
        self.session = URLSession(configuration: sessionConfig)
        
        // Configure JSON decoder
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Try ISO8601 with fractional seconds first
            let iso8601Formatter = ISO8601DateFormatter()
            iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = iso8601Formatter.date(from: dateString) {
                return date
            }
            
            // Try ISO8601 without fractional seconds
            iso8601Formatter.formatOptions = [.withInternetDateTime]
            if let date = iso8601Formatter.date(from: dateString) {
                return date
            }
            
            // Try simple date format (YYYY-MM-DD)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date string does not match expected formats: \(dateString)")
        }
        
        // Configure JSON encoder
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
    }
    
    /// Performs a GET request to the specified endpoint
    public func get<T: Decodable>(_ endpoint: String, queryItems: [URLQueryItem]?) async throws -> T {
        let request = try buildRequest(endpoint: endpoint, method: .get, queryItems: queryItems)
        return try await perform(request)
    }
    
    /// Performs a POST request to the specified endpoint
    public func post<T: Decodable, U: Encodable>(_ endpoint: String, body: U) async throws -> T {
        var request = try buildRequest(endpoint: endpoint, method: .post)
        request.httpBody = try encoder.encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return try await perform(request)
    }
    
    /// Performs a PUT request to the specified endpoint
    public func put<T: Decodable, U: Encodable>(_ endpoint: String, body: U) async throws -> T {
        var request = try buildRequest(endpoint: endpoint, method: .put)
        request.httpBody = try encoder.encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return try await perform(request)
    }
    
    /// Performs a DELETE request to the specified endpoint
    public func delete<T: Decodable>(_ endpoint: String) async throws -> T {
        let request = try buildRequest(endpoint: endpoint, method: .delete)
        return try await perform(request)
    }
    
    // MARK: - Private Methods
    
    private func buildRequest(
        endpoint: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem]? = nil
    ) throws -> URLRequest {
        // Build URL
        guard var components = URLComponents(string: configuration.baseURL.absoluteString + endpoint) else {
            throw SpeedrunError.invalidURL(endpoint)
        }
        
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw SpeedrunError.invalidURL(endpoint)
        }
        
        // Build request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add API key if available
        if let apiKey = configuration.apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        }
        
        return request
    }
    
    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        var lastError: Error?
        
        for attempt in 0..<configuration.maxRetries {
            if attempt > 0 {
                // Exponential backoff
                let delay = TimeInterval(pow(2.0, Double(attempt - 1)))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            do {
                let (data, response) = try await session.data(for: request)
                
                if configuration.debugLogging {
                    debugPrint(request, data: data, response: response)
                }
                
                try validateResponse(response, data: data)
                
                return try decoder.decode(T.self, from: data)
            } catch let error as SpeedrunError {
                switch error {
                case .rateLimitExceeded:
                    // Retry for rate limit
                    lastError = error
                    continue
                case .networkError:
                    // Retry for network errors
                    lastError = error
                    continue
                default:
                    // Don't retry for other errors
                    throw error
                }
            } catch {
                // Retry for decoding or other errors
                lastError = error
                continue
            }
        }
        
        throw lastError ?? SpeedrunError.unknown("Max retries exceeded")
    }
    
    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SpeedrunError.unknown("Invalid response type")
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw SpeedrunError.authenticationRequired
        case 403:
            throw SpeedrunError.invalidAPIKey
        case 429:
            throw SpeedrunError.rateLimitExceeded
        default:
            // Try to decode error response
            if let apiError = try? decoder.decode(APIError.self, from: data) {
                throw SpeedrunError.apiError(apiError)
            } else {
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw SpeedrunError.httpError(statusCode: httpResponse.statusCode, message: message)
            }
        }
    }
    
    private func debugPrint(_ request: URLRequest, data: Data, response: URLResponse) {
        print("=== SpeedrunKit Request ===")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        
        print("\n=== SpeedrunKit Response ===")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("Body: \(responseString)")
        }
        print("========================\n")
    }
}