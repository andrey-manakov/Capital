@testable import Capital
import XCTest

internal final class AccountGroupDetailVCTests: XCTestCase {
    // MARK: Subject under test

    internal var sut: AccountGroupDetailVC!
    internal var view: UIView!
    internal var window: UIWindow!

    // MARK: Test lifecycle

    override internal func setUp() {
        super.setUp()
        window = UIWindow()
        setupVC()
    }

    override internal func tearDown() {
        window = nil
        sut = nil // TODO: Check if it is needed
        view = nil // TODO: Check if it is needed
        super.tearDown()
    }

    // MARK: Test setup

    internal func setupVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        sut = AccountGroupDetailVC("id")
        view = sut.view
        self.window?.rootViewController = sut
        self.window!.makeKeyAndVisible()
    }

    internal func loadView() {
        window.addSubview(view)
        RunLoop.current.run(until: Date())
    }

    internal func testViewDidLoad() {
        XCTAssert(view.subviews.count == 1 && "\(type(of: view.subviews[0]))" == "SimpleTable")
    }
}
