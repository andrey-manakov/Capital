import XCTest
@testable import Capital

internal final class AccountNewVCTests: XCTestCase {

    // MARK: Subject under test

    private var sut: AccountNewVC!
    private var view: UIView!
    private var window: UIWindow!

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
        sut = AccountNewVC()
        view = sut.view
        self.window?.rootViewController = sut
        self.window!.makeKeyAndVisible()
    }

    internal func loadView() {
        window.addSubview(view)
        RunLoop.current.run(until: Date())
    }

    internal func testViewDidLoad() {
        XCTAssert(view.views["sc"] as? SegmentedControl != nil &&
            view.views["an"] as? SimpleTextField != nil &&
            view.views["aa"] as? SimpleTextField != nil)
    }

}
