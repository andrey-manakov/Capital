@testable import Capital
import XCTest

internal class EmailFieldTests: XCTestCase {
    internal func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = EmailField(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }
}
