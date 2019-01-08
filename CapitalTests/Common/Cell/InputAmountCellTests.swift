import XCTest
@testable import Capital

class InputAmountCellTests: XCTestCase {

    func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view =  InputAmountCell(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }

}
