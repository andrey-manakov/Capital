@testable import Capital
import XCTest

internal class BinaryIntegerExtensionTest: XCTestCase {
    internal func testWithRightArgument() {
        // 1. Arrange
        // TODO: Use random number
        let number = 9_999_999_999

        // 2. Action
        let formattedNumber = number.formattedWithSeparator

        // 3. Assert
        XCTAssert(formattedNumber == "9 999 999 999")
    }
}
