@testable import Capital
import XCTest

internal final class AccountSelectorVCTests: XCTestCase {
    // MARK: Subject under test

    private var sut: AccountSelectorVC?
    private var view: UIView?
    private var window: UIWindow?

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

    private func setupVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        sut = AccountSelectorVC()
        view = sut?.view
        self.window?.rootViewController = sut
        self.window?.makeKeyAndVisible()
    }

    private func loadView() {
        if let window = window, let view = view {
            window.addSubview(view)
        }
        RunLoop.current.run(until: Date())
    }

    internal func testViewDidLoad() {
        guard let view = view else {
            XCTFail("Error accessing view controller's view")
            return
        }
        XCTAssert(view.views["t"] as? SimpleTableWithSwipe != nil &&
            view.views["sc"] as? SegmentedControl != nil)
    }
}
