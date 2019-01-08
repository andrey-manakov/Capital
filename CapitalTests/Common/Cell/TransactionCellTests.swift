import XCTest
@testable import Capital

class TransactionCellTests: XCTestCase {

    func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = TransactionCell(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }

}
