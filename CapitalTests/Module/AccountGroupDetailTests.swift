
import XCTest
@testable import Capital


class AccountGroupDetailVCTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: AccountGroupDetailVC!
    var view: UIView!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupVC()
    }
    
    override func tearDown()
    {
        window = nil
        sut = nil // TODO: Check if it is needed
        view = nil // TODO: Check if it is needed
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupVC()
    {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        sut = AccountGroupDetailVC("id")
        view = sut.view
        self.window?.rootViewController = sut
        self.window!.makeKeyAndVisible()
    }
    
    func loadView() {
        window.addSubview(view)
        RunLoop.current.run(until: Date())
    }
    
    func testViewDidLoad() {
        XCTAssert(view.subviews.count == 1 && "\(type(of: view.subviews[0]))" == "SimpleTable")
    }
    
//    func testAccountDelete() {
//        var result = false
//        if let views = view?.subviews {
//            for view in views {
//                if let deleteButton = view as? Button, deleteButton.accessibilityIdentifier == "deleteButton" {
//                    deleteButton.sendActions(for: UIControl.Event.touchUpInside)
//                }
//            }
//        } else {XCTAssert(false)}
//        if let data = Data.shared as? DataMock, data.deleteAccountCalled == true  {result = true}
//        XCTAssert(result)
//    }
    
//    func testViewDidLoad() {
//        var result = true
//        let viewsSet: Set<String> = ["accountName", "accountAmount", "deleteButton"]
//
//        if let views = view?.subviews {
//            let viewsNames = Set(views.map{$0.accessibilityIdentifier ?? ""})
//            if viewsSet != viewsNames {
//                result = false
//            }
//        } else {
//            XCTAssert(false)
//        }
//        XCTAssert(result)
//    }
    
//    func testDoneButton() {
//        let item = sut.navigationItem.rightBarButtonItem
//        item?.perform(item?.action)
//        XCTAssert((Data.shared as? DataMock)?.updateAccountCalled ?? false)
//    }
    
}
