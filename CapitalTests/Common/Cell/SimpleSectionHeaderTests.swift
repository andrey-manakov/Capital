import XCTest
@testable import Capital

class SimpleSectionHeaderTests: XCTestCase {

    func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = SimpleSectionHeader(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }

}
