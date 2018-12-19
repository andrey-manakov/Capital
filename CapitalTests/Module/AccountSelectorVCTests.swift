
import XCTest
@testable import Capital


class AccountSelectorVCTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: AccountSelectorVC!
    var view: UIView!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupVC()
    }
    
    override func tearDown() {
        window = nil
        sut = nil // TODO: Check if it is needed
        view = nil // TODO: Check if it is needed
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        sut = AccountSelectorVC()
        view = sut.view
        self.window?.rootViewController = sut
        self.window!.makeKeyAndVisible()
    }
    
    func loadView() {
        window.addSubview(view)
        RunLoop.current.run(until: Date())
    }
    
    func testViewDidLoad() {
        XCTAssert(view.views["t"] as? SimpleTableWithSwipe != nil &&
            view.views["sc"] as? SegmentedControl != nil)
    }
    
}
