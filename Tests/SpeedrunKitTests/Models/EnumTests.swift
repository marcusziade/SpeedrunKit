import XCTest
@testable import SpeedrunKit

final class EnumTests: XCTestCase {
    // MARK: - TimingMethod Tests
    
    func testTimingMethodRawValues() {
        XCTAssertEqual(TimingMethod.realtime.rawValue, "realtime")
        XCTAssertEqual(TimingMethod.realtimeNoLoads.rawValue, "realtime_noloads")
        XCTAssertEqual(TimingMethod.ingame.rawValue, "ingame")
    }
    
    func testTimingMethodDecoding() throws {
        let json = """
        ["realtime", "realtime_noloads", "ingame"]
        """
        
        let data = json.data(using: .utf8)!
        let methods = try JSONDecoder().decode([TimingMethod].self, from: data)
        
        XCTAssertEqual(methods, [.realtime, .realtimeNoLoads, .ingame])
    }
    
    // MARK: - ModeratorRole Tests
    
    func testModeratorRoleRawValues() {
        XCTAssertEqual(ModeratorRole.moderator.rawValue, "moderator")
        XCTAssertEqual(ModeratorRole.superModerator.rawValue, "super-moderator")
    }
    
    // MARK: - CategoryType Tests
    
    func testCategoryTypeRawValues() {
        XCTAssertEqual(CategoryType.perGame.rawValue, "per-game")
        XCTAssertEqual(CategoryType.perLevel.rawValue, "per-level")
    }
    
    // MARK: - UserRole Tests
    
    func testUserRoleRawValues() {
        XCTAssertEqual(UserRole.banned.rawValue, "banned")
        XCTAssertEqual(UserRole.user.rawValue, "user")
        XCTAssertEqual(UserRole.trusted.rawValue, "trusted")
        XCTAssertEqual(UserRole.moderator.rawValue, "moderator")
        XCTAssertEqual(UserRole.admin.rawValue, "admin")
        XCTAssertEqual(UserRole.programmer.rawValue, "programmer")
    }
    
    // MARK: - RunStatus Tests
    
    func testRunStatusValues() {
        XCTAssertEqual(RunStatus.Status.new.rawValue, "new")
        XCTAssertEqual(RunStatus.Status.verified.rawValue, "verified")
        XCTAssertEqual(RunStatus.Status.rejected.rawValue, "rejected")
    }
    
    // MARK: - NotificationStatus Tests
    
    func testNotificationStatusValues() {
        XCTAssertEqual(NotificationStatus.read.rawValue, "read")
        XCTAssertEqual(NotificationStatus.unread.rawValue, "unread")
    }
    
    // MARK: - HTTPMethod Tests
    
    func testHTTPMethodValues() {
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
        XCTAssertEqual(HTTPMethod.post.rawValue, "POST")
        XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
        XCTAssertEqual(HTTPMethod.delete.rawValue, "DELETE")
        XCTAssertEqual(HTTPMethod.patch.rawValue, "PATCH")
    }
}