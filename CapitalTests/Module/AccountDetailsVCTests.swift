import XCTest
@testable import Capital

class AccountDetailVCTests: XCTestCase {

    // MARK: Subject under test

    var sut: AccountDetailVC!
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
        sut = AccountDetailVC("account id")
        view = sut.view
        self.window?.rootViewController = sut
        self.window!.makeKeyAndVisible()
    }

    func loadView() {
        window.addSubview(view)
        RunLoop.current.run(until: Date())
    }

    func testAccountDelete() {
        guard let views = view?.subviews else {
            XCTFail("problem with view controller view")
            return}
        for view in views {
            guard let deleteButton = view as? Button,
                deleteButton.accessibilityIdentifier == "deleteButton" else {continue}
            deleteButton.sendActions(for: UIControl.Event.touchUpInside)
        }
        XCTAssert(Data.sharedForUnitTests.deleteAccountCalled)
    }

    func testViewDidLoad() {
        var result = true
        let viewsSet: Set<String> = ["accountName", "accountAmount", "deleteButton"]

        if let views = view?.subviews {
            let viewsNames = Set(views.map {$0.accessibilityIdentifier ?? ""})
            if viewsSet != viewsNames {
                result = false
            }
        } else {
            XCTAssert(false)
        }
        XCTAssert(result)
    }

    func testDoneButton() {
        let item = sut.navigationItem.rightBarButtonItem
        item?.perform(item?.action)
        XCTAssert(Data.sharedForUnitTests.updateAccountCalled)
    }
}
