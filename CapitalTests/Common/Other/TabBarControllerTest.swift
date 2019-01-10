import XCTest
@testable import Capital

internal class TabBarControllerTests: XCTestCase {

    /// Test check that TabBar controller gets 5 pages:
    /// DashBoard, Accounts, New Transaction, Transactions, Settings
    internal func testInitWithVC() {
        let tabVC = TabBarController()
        let navVC = tabVC.viewControllers?[0] as? NavigationController
        XCTAssertTrue(navVC?.viewControllers[0] as? AccountGroupsViewController != nil)
        // FIXME: add the rest VCs
    }

}
