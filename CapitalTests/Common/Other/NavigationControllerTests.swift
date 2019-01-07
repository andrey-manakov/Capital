import XCTest
@testable import Capital

class NavigationControllerTests: XCTestCase {
    /// Test check that Navigation could be initialized with VC argument which becomes root view controller of navigation controller
    func testInitWithVC() {
        let vc = UIViewController()
        let nvc = NavigationController(vc)
        XCTAssertEqual(nvc.viewControllers[0], vc)
    }
}
