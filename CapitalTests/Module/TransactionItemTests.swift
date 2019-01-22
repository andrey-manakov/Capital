@testable import Capital
import XCTest

internal final class TransactionItemTests: XCTestCase {
    internal func testName() {
        XCTAssertTrue(TransactionItem.amount.name == "amount" &&
        TransactionItem.approvalMode.name == "approval mode" &&
        TransactionItem.date.name == "date" &&
        TransactionItem.from.name == "from" &&
        TransactionItem.recurrenceEnd.name == "end repeat" &&
        TransactionItem.recurrenceFrequency.name == "repeat")
    }

    internal func testHeight() {
        for item in TransactionItem.allCases {
            if (item == .dateSelection || item == .recurrenceEndDate) && item.height != 200 {
                XCTFail("height is wrong")
            }
            if (item != .dateSelection && item != .recurrenceEndDate) && item.height != 45 {
                XCTFail("height is wrong")
            }
        }
    }
}
