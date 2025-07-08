import XCTest
@testable import SpeedrunKit

final class LinkTests: XCTestCase {
    func testInitializationWithRel() {
        let link = Link(rel: "self", uri: "https://www.speedrun.com/api/v1/games/sm64")
        XCTAssertEqual(link.rel, "self")
        XCTAssertEqual(link.uri, "https://www.speedrun.com/api/v1/games/sm64")
    }
    
    func testInitializationWithoutRel() {
        let link = Link(uri: "https://www.speedrun.com/api/v1/runs/123")
        XCTAssertNil(link.rel)
        XCTAssertEqual(link.uri, "https://www.speedrun.com/api/v1/runs/123")
    }
    
    func testDecoding() throws {
        let json = """
        {
            "rel": "game",
            "uri": "https://www.speedrun.com/api/v1/games/abc123"
        }
        """
        
        let data = json.data(using: .utf8)!
        let link = try JSONDecoder().decode(Link.self, from: data)
        
        XCTAssertEqual(link.rel, "game")
        XCTAssertEqual(link.uri, "https://www.speedrun.com/api/v1/games/abc123")
    }
    
    func testDecodingWithoutRel() throws {
        let json = """
        {
            "uri": "https://www.speedrun.com/api/v1/users/xyz789"
        }
        """
        
        let data = json.data(using: .utf8)!
        let link = try JSONDecoder().decode(Link.self, from: data)
        
        XCTAssertNil(link.rel)
        XCTAssertEqual(link.uri, "https://www.speedrun.com/api/v1/users/xyz789")
    }
    
    func testEncoding() throws {
        let link = Link(rel: "category", uri: "https://www.speedrun.com/api/v1/categories/any")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let data = try encoder.encode(link)
        let json = String(data: data, encoding: .utf8)!
        
        XCTAssertEqual(json, "{\"rel\":\"category\",\"uri\":\"https:\\/\\/www.speedrun.com\\/api\\/v1\\/categories\\/any\"}")
    }
    
    func testEquality() {
        let link1 = Link(rel: "self", uri: "https://example.com/api/v1/resource")
        let link2 = Link(rel: "self", uri: "https://example.com/api/v1/resource")
        let link3 = Link(rel: "other", uri: "https://example.com/api/v1/resource")
        let link4 = Link(rel: "self", uri: "https://example.com/api/v1/different")
        
        XCTAssertEqual(link1, link2)
        XCTAssertNotEqual(link1, link3)
        XCTAssertNotEqual(link1, link4)
    }
}