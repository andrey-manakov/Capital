@testable import Capital
import XCTest

internal class SimpleLabelTests: XCTestCase {
    internal func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = SimpleLabel(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }

    internal func testInitWithText() {
        // given
        let text = "1"
        // when
        let sample = SimpleLabel(text)
        // then
        XCTAssertTrue(sample.text == text)
    }

    internal func testInitWithStringAlignLines() {
        // given
        let text = "1"
        let alignment = NSTextAlignment.right
        let lines = 10

        // when
        let sample = SimpleLabel(text, alignment: alignment, lines: lines)

        // then
        XCTAssertTrue(sample.text == text &&
            sample.textAlignment == alignment &&
            sample.numberOfLines == lines)
    }
}
