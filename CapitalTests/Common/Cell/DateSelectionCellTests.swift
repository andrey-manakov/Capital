import XCTest
@testable import Capital

class DateSelectionCellTests: XCTestCase {
    func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view =  DateSelectionCell(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }
}
