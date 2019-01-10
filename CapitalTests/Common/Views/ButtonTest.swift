import XCTest
@testable import Capital

internal class ButtonTest: XCTestCase {

    internal func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)

        // 2. Action
        let view = Button(coder: archiver)

        // 3. Assert
        XCTAssertNil(view)
    }

    internal func testTapAction() {
        // 1. Arrange
        var buttonActionWasCalled = false
        let action: (() -> Void)? = {
            buttonActionWasCalled = true
        }
        let button = Button(name: "", action: action!)

        // 2. Action
        button.sendActions(for: UIControl.Event.touchUpInside)

        // 3. Assert
        XCTAssert(buttonActionWasCalled)
    }

}
