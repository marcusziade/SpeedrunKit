import XCTest
@testable import SpeedrunKit

/// Main test suite for SpeedrunKit
final class SpeedrunKitTests: XCTestCase {
    func testSpeedrunClientInitialization() {
        let client = SpeedrunClient()
        XCTAssertNotNil(client.configuration)
        XCTAssertEqual(client.configuration.baseURL.absoluteString, "https://www.speedrun.com/api/v1")
        XCTAssertNil(client.configuration.apiKey)
    }
    
    func testSpeedrunClientWithCustomConfiguration() {
        let config = SpeedrunConfiguration(
            apiKey: "test-key",
            timeoutInterval: 60,
            debugLogging: true
        )
        let client = SpeedrunClient(configuration: config)
        
        XCTAssertEqual(client.configuration.apiKey, "test-key")
        XCTAssertEqual(client.configuration.timeoutInterval, 60)
        XCTAssertTrue(client.configuration.debugLogging)
    }
    
    func testSpeedrunClientAPISections() {
        let client = SpeedrunClient()
        
        // Verify all API sections are available
        XCTAssertNotNil(client.games)
        XCTAssertNotNil(client.categories)
        XCTAssertNotNil(client.levels)
        XCTAssertNotNil(client.variables)
        XCTAssertNotNil(client.runs)
        XCTAssertNotNil(client.users)
        XCTAssertNotNil(client.leaderboards)
        XCTAssertNotNil(client.series)
        XCTAssertNotNil(client.platforms)
        XCTAssertNotNil(client.regions)
        XCTAssertNotNil(client.genres)
        XCTAssertNotNil(client.profile)
    }
}
