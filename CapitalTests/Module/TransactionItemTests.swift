import XCTest
@testable import Capital

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

// var name: String {
//    switch self {
//    case .from: return "from"
//    case .to: return "to"
//    case .amount: return "amount"
//    case .date: return "date"
//    case .dateSelection: return ""
//    case .approvalMode: return "approval mode"
//    case .recurrenceFrequency: return "repeat"
//    case .recurrenceEnd: return "end repeat"
//    case .recurrenceEndDate: return ""
//    }
// }
