import XCTest
@testable import SpeedrunKit

final class NamesTests: XCTestCase {
    func testInitialization() {
        let names = Names(international: "Super Mario 64", japanese: "スーパーマリオ64")
        XCTAssertEqual(names.international, "Super Mario 64")
        XCTAssertEqual(names.japanese, "スーパーマリオ64")
    }
    
    func testInitializationWithoutJapanese() {
        let names = Names(international: "Portal")
        XCTAssertEqual(names.international, "Portal")
        XCTAssertNil(names.japanese)
    }
    
    func testDecoding() throws {
        let json = """
        {
            "international": "The Legend of Zelda",
            "japanese": "ゼルダの伝説"
        }
        """
        
        let data = json.data(using: .utf8)!
        let names = try JSONDecoder().decode(Names.self, from: data)
        
        XCTAssertEqual(names.international, "The Legend of Zelda")
        XCTAssertEqual(names.japanese, "ゼルダの伝説")
    }
    
    func testEncoding() throws {
        let names = Names(international: "Metroid", japanese: "メトロイド")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let data = try encoder.encode(names)
        let json = String(data: data, encoding: .utf8)!
        
        XCTAssertEqual(json, "{\"international\":\"Metroid\",\"japanese\":\"メトロイド\"}")
    }
    
    func testEquality() {
        let names1 = Names(international: "Sonic", japanese: "ソニック")
        let names2 = Names(international: "Sonic", japanese: "ソニック")
        let names3 = Names(international: "Sonic", japanese: nil)
        
        XCTAssertEqual(names1, names2)
        XCTAssertNotEqual(names1, names3)
    }
}