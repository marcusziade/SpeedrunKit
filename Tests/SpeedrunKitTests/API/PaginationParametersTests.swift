import XCTest
@testable import SpeedrunKit

final class PaginationParametersTests: XCTestCase {
    func testInitialization() {
        let params = PaginationParameters(
            max: 50,
            offset: 100,
            orderby: "name",
            direction: .ascending
        )
        
        XCTAssertEqual(params.max, 50)
        XCTAssertEqual(params.offset, 100)
        XCTAssertEqual(params.orderby, "name")
        XCTAssertEqual(params.direction, .ascending)
    }
    
    func testDefaultInitialization() {
        let params = PaginationParameters()
        
        XCTAssertNil(params.max)
        XCTAssertNil(params.offset)
        XCTAssertNil(params.orderby)
        XCTAssertNil(params.direction)
    }
    
    func testToURLQueryItems() {
        let params = PaginationParameters(
            max: 20,
            offset: 40,
            orderby: "created",
            direction: .descending
        )
        
        let queryItems = params.toURLQueryItems()
        
        XCTAssertEqual(queryItems.count, 4)
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "max", value: "20")))
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "offset", value: "40")))
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "orderby", value: "created")))
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "direction", value: "desc")))
    }
    
    func testToURLQueryItemsWithNilValues() {
        let params = PaginationParameters(max: 10)
        let queryItems = params.toURLQueryItems()
        
        XCTAssertEqual(queryItems.count, 1)
        XCTAssertEqual(queryItems.first, URLQueryItem(name: "max", value: "10"))
    }
    
    func testSortDirectionRawValues() {
        XCTAssertEqual(SortDirection.ascending.rawValue, "asc")
        XCTAssertEqual(SortDirection.descending.rawValue, "desc")
    }
}