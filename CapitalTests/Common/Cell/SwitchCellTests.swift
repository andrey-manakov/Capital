import XCTest
@testable import Capital

internal final class SwitchCellTests: XCTestCase {

    internal func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = SwitchCell(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }

}
