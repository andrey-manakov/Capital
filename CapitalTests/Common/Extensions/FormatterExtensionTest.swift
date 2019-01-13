@testable import Capital
import XCTest

internal class FormatterExtensionTest: XCTestCase {
    internal func testWithRightArgument() {
        // 1. Arrange
        let numberFormatter = Formatter.withSeparator

        // 2. Action

        // 3. Assert
        XCTAssert(
            numberFormatter.groupingSeparator == " " &&
            numberFormatter.numberStyle == NumberFormatter.Style.decimal
        )
    }
}
