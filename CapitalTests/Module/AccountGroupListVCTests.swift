@testable import Capital
import XCTest

internal final class AccountGroupListVCTests: XCTestCase {
    // MARK: Subject under test

    internal var sut: AccountListVC?
    internal var view: UIView?
    internal var window: UIWindow?

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
        sut = AccountListVC()
        view = sut?.view
        self.window?.rootViewController = sut
        self.window?.makeKeyAndVisible()
    }

    internal func loadView() {
        if let window = window, let view = view {
            window.addSubview(view)
        }
        RunLoop.current.run(until: Date())
    }

    internal func testViewDidLoad() {
        guard let view = view else {
            XCTFail("View doesn't exist")
            return
        }
        XCTAssert(view.views["t"] as? SimpleTable != nil && view.views["sc"] as? SegmentedControl != nil)
    }
}
