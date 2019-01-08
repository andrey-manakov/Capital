import XCTest
@testable import Capital

class NavigationControllerTests: XCTestCase {

    /// Test checks that Navigation could be initialized with VC argument,
    /// which becomes root view controller of navigation controller
    func testInitWithVC() {
        let viewController = UIViewController()
        let nvc = NavigationController(viewController)
        XCTAssertEqual(nvc.viewControllers[0], viewController)
    }

}
