import XCTest
@testable import Capital

internal class TitleLabelTests: XCTestCase {

    internal func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = TitleLabel(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }

    internal func testInitWithTest() {
        // 1. Arrange
        let text = "title"

        // 2. Action
        let view = TitleLabel(text)

        // 3. Assert
        XCTAssert(view.text == text &&
            view.font == UIFont(name: "HelveticaNeue-Bold", size: 20) &&
            view.textAlignment == .center)
    }

}
