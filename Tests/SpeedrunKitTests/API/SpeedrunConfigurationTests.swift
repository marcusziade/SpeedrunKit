import XCTest
@testable import SpeedrunKit

final class SpeedrunConfigurationTests: XCTestCase {
    func testDefaultConfiguration() {
        let config = SpeedrunConfiguration.default
        
        XCTAssertEqual(config.baseURL.absoluteString, "https://www.speedrun.com/api/v1")
        XCTAssertNil(config.apiKey)
        XCTAssertEqual(config.timeoutInterval, 30)
        XCTAssertEqual(config.maxRetries, 3)
        XCTAssertFalse(config.debugLogging)
    }
    
    func testCustomConfiguration() {
        let customURL = URL(string: "https://custom.api.com/v2")!
        let config = SpeedrunConfiguration(
            baseURL: customURL,
            apiKey: "test-api-key",
            timeoutInterval: 60,
            maxRetries: 5,
            debugLogging: true
        )
        
        XCTAssertEqual(config.baseURL, customURL)
        XCTAssertEqual(config.apiKey, "test-api-key")
        XCTAssertEqual(config.timeoutInterval, 60)
        XCTAssertEqual(config.maxRetries, 5)
        XCTAssertTrue(config.debugLogging)
    }
    
    func testPartialCustomConfiguration() {
        let config = SpeedrunConfiguration(apiKey: "my-key")
        
        XCTAssertEqual(config.baseURL.absoluteString, "https://www.speedrun.com/api/v1")
        XCTAssertEqual(config.apiKey, "my-key")
        XCTAssertEqual(config.timeoutInterval, 30)
        XCTAssertEqual(config.maxRetries, 3)
        XCTAssertFalse(config.debugLogging)
    }
}