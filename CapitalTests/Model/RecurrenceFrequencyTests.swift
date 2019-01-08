import XCTest
@testable import Capital

class RecurrenceFrequencyTests: XCTestCase {
    func testName() {
        for item in RecurrenceFrequency.allCases {
            switch item {
            case .everyDay: XCTAssert(item.name == "Every Day")
            case .everyMonth: XCTAssert(item.name == "Every Month")
            case .everyWeek: XCTAssert(item.name == "Every Week")
            case .everyWorkingDay: XCTAssert(item.name == "Every Working Day")
            case .everyYear: XCTAssert(item.name == "Every Year")
            case .never: XCTAssert(item.name == "Never")
            }
        }
    }

}
