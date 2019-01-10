import XCTest
@testable import Capital

class SimpleTableWithSelectionTests: XCTestCase {

    func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = SimpleTableWithSelection(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }

}
