import XCTest
@testable import SpeedrunKit

final class ColorTests: XCTestCase {
    func testInitialization() {
        let color = Color(light: "#FF0000", dark: "#CC0000")
        XCTAssertEqual(color.light, "#FF0000")
        XCTAssertEqual(color.dark, "#CC0000")
    }
    
    func testDecoding() throws {
        let json = """
        {
            "light": "#1E88E5",
            "dark": "#0D47A1"
        }
        """
        
        let data = json.data(using: .utf8)!
        let color = try JSONDecoder().decode(Color.self, from: data)
        
        XCTAssertEqual(color.light, "#1E88E5")
        XCTAssertEqual(color.dark, "#0D47A1")
    }
    
    func testEncoding() throws {
        let color = Color(light: "#4CAF50", dark: "#1B5E20")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let data = try encoder.encode(color)
        let json = String(data: data, encoding: .utf8)!
        
        XCTAssertEqual(json, "{\"dark\":\"#1B5E20\",\"light\":\"#4CAF50\"}")
    }
    
    func testEquality() {
        let color1 = Color(light: "#FFFFFF", dark: "#000000")
        let color2 = Color(light: "#FFFFFF", dark: "#000000")
        let color3 = Color(light: "#FFFFFF", dark: "#333333")
        
        XCTAssertEqual(color1, color2)
        XCTAssertNotEqual(color1, color3)
    }
}