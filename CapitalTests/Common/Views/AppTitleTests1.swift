import XCTest
@testable import Capital

internal class AppTitleTests: XCTestCase {

    internal func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = AppTitle(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }

}
