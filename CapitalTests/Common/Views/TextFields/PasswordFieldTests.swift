@testable import Capital
import XCTest

internal class PasswordFieldTests: XCTestCase {
    internal func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = PasswordField(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }
}
