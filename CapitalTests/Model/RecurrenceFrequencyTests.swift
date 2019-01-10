import XCTest
@testable import Capital

internal class RecurrenceFrequencyTests: XCTestCase {

    internal func testName() {
        for item in RecurrenceFrequency.allCases {
            let nameIsCorrect: Bool
            switch item {
            case .everyDay:
                nameIsCorrect = (item.name == "Every Day")
            case .everyMonth:
                nameIsCorrect = (item.name == "Every Month")
            case .everyWeek:
                nameIsCorrect = (item.name == "Every Week")
            case .everyWorkingDay:
                nameIsCorrect = (item.name == "Every Working Day")
            case .everyYear:
                nameIsCorrect = (item.name == "Every Year")
            case .never:
                nameIsCorrect = (item.name == "Never")
            }
            XCTAssert(nameIsCorrect)
        }
    }

}
