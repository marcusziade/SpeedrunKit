import XCTest
@testable import SpeedrunKit

final class SpeedrunErrorTests: XCTestCase {
    func testErrorDescriptions() {
        let networkError = SpeedrunError.networkError(NSError(domain: "test", code: -1))
        XCTAssertTrue(networkError.errorDescription?.contains("Network error") ?? false)
        
        let invalidURLError = SpeedrunError.invalidURL("/invalid/url")
        XCTAssertEqual(invalidURLError.errorDescription, "Invalid URL: /invalid/url")
        
        let httpError = SpeedrunError.httpError(statusCode: 404, message: "Not found")
        XCTAssertEqual(httpError.errorDescription, "HTTP error 404: Not found")
        
        let httpErrorNoMessage = SpeedrunError.httpError(statusCode: 500, message: nil)
        XCTAssertEqual(httpErrorNoMessage.errorDescription, "HTTP error 500: No message")
        
        let decodingError = SpeedrunError.decodingError(NSError(domain: "decode", code: -1))
        XCTAssertTrue(decodingError.errorDescription?.contains("Decoding error") ?? false)
        
        let apiError = SpeedrunError.apiError(APIError(
            status: 400,
            message: "Bad request",
            errors: ["Invalid parameter"],
            links: nil
        ))
        XCTAssertEqual(apiError.errorDescription, "API error: Bad request")
        
        let authError = SpeedrunError.authenticationRequired
        XCTAssertEqual(authError.errorDescription, "Authentication required. Please provide an API key.")
        
        let invalidKeyError = SpeedrunError.invalidAPIKey
        XCTAssertEqual(invalidKeyError.errorDescription, "Invalid API key")
        
        let rateLimitError = SpeedrunError.rateLimitExceeded
        XCTAssertEqual(rateLimitError.errorDescription, "Rate limit exceeded. Please try again later.")
        
        let unknownError = SpeedrunError.unknown("Something went wrong")
        XCTAssertEqual(unknownError.errorDescription, "Unknown error: Something went wrong")
    }
    
    func testAPIErrorDecoding() throws {
        let json = """
        {
            "status": 404,
            "message": "Resource not found",
            "errors": ["Game not found", "Invalid ID format"],
            "links": [
                {
                    "rel": "support",
                    "uri": "https://www.speedrun.com/support"
                }
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        let apiError = try JSONDecoder().decode(APIError.self, from: data)
        
        XCTAssertEqual(apiError.status, 404)
        XCTAssertEqual(apiError.message, "Resource not found")
        XCTAssertEqual(apiError.errors?.count, 2)
        XCTAssertEqual(apiError.errors?.first, "Game not found")
        XCTAssertEqual(apiError.links?.count, 1)
        XCTAssertEqual(apiError.links?.first?.rel, "support")
    }
}