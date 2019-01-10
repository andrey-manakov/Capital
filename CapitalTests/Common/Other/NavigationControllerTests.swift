import XCTest
@testable import Capital

internal final class NavigationControllerTests: XCTestCase {

    /// Test checks that Navigation could be initialized with VC argument,
    /// which becomes root view controller of navigation controller
    internal func testInitWithVC() {
        let viewController = UIViewController()
        let nvc = NavigationController(viewController)
        XCTAssertEqual(nvc.viewControllers[0], viewController)
    }

}
