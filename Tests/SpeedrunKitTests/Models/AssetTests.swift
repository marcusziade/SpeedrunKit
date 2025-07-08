import XCTest
@testable import SpeedrunKit

final class AssetTests: XCTestCase {
    func testInitialization() {
        let asset = Asset(uri: "https://example.com/image.jpg", width: 256, height: 256)
        XCTAssertEqual(asset.uri, "https://example.com/image.jpg")
        XCTAssertEqual(asset.width, 256)
        XCTAssertEqual(asset.height, 256)
    }
    
    func testInitializationWithoutDimensions() {
        let asset = Asset(uri: "https://example.com/image.jpg")
        XCTAssertEqual(asset.uri, "https://example.com/image.jpg")
        XCTAssertNil(asset.width)
        XCTAssertNil(asset.height)
        XCTAssertTrue(asset.isValid)
    }
    
    func testInitializationWithNullUri() {
        let asset = Asset(uri: nil)
        XCTAssertNil(asset.uri)
        XCTAssertNil(asset.width)
        XCTAssertNil(asset.height)
        XCTAssertFalse(asset.isValid)
    }
    
    func testDecoding() throws {
        let json = """
        {
            "uri": "https://www.speedrun.com/themes/sm64/cover-256.png",
            "width": 256,
            "height": 361
        }
        """
        
        let data = json.data(using: .utf8)!
        let asset = try JSONDecoder().decode(Asset.self, from: data)
        
        XCTAssertEqual(asset.uri, "https://www.speedrun.com/themes/sm64/cover-256.png")
        XCTAssertEqual(asset.width, 256)
        XCTAssertEqual(asset.height, 361)
    }
    
    func testDecodingWithoutDimensions() throws {
        let json = """
        {
            "uri": "https://www.speedrun.com/images/logo.png"
        }
        """
        
        let data = json.data(using: .utf8)!
        let asset = try JSONDecoder().decode(Asset.self, from: data)
        
        XCTAssertEqual(asset.uri, "https://www.speedrun.com/images/logo.png")
        XCTAssertNil(asset.width)
        XCTAssertNil(asset.height)
    }
    
    func testDecodingWithNullUri() throws {
        let json = """
        {
            "uri": null
        }
        """
        
        let data = json.data(using: .utf8)!
        let asset = try JSONDecoder().decode(Asset.self, from: data)
        
        XCTAssertNil(asset.uri)
        XCTAssertNil(asset.width)
        XCTAssertNil(asset.height)
        XCTAssertFalse(asset.isValid)
    }
    
    func testEncoding() throws {
        let asset = Asset(uri: "https://example.com/logo.png", width: 128, height: 64)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let data = try encoder.encode(asset)
        let json = String(data: data, encoding: .utf8)!
        
        XCTAssertEqual(json, "{\"height\":64,\"uri\":\"https:\\/\\/example.com\\/logo.png\",\"width\":128}")
    }
    
    func testEquality() {
        let asset1 = Asset(uri: "https://example.com/img.jpg", width: 100, height: 100)
        let asset2 = Asset(uri: "https://example.com/img.jpg", width: 100, height: 100)
        let asset3 = Asset(uri: "https://example.com/img.jpg", width: 200, height: 200)
        
        XCTAssertEqual(asset1, asset2)
        XCTAssertNotEqual(asset1, asset3)
    }
}