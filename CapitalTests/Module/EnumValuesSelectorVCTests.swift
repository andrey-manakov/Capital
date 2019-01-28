@testable import Capital
import XCTest

internal final class EnumValuesSelectorVCTests: XCTestCase {
    // MARK: Subject under test

    internal var sut: EnumValuesSelectorVC?
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
        sut = EnumValuesSelectorVC()
        view = sut?.view
        self.window?.rootViewController = sut
        self.window?.makeKeyAndVisible()
    }

    internal func loadView() {
        window?.addSubview(view ?? UIView())
        RunLoop.current.run(until: Date())
    }

//    internal func testAccountDelete() {
//        guard let views = view?.subviews else {
//            XCTFail("problem with view controller view")
//            return}
//        for view in views {
//            guard let deleteButton = view as? Button,
//                deleteButton.accessibilityIdentifier == "deleteButton" else { continue }
//            deleteButton.sendActions(for: UIControl.Event.touchUpInside)
//        }
//        XCTAssert(Data.sharedForUnitTests.deleteAccountCalled)
//    }

    internal func testViewDidLoad() {
        var result = true
        let viewsSet: Set<String> = ["v"]

        if let views = view?.subviews {
            let viewsNames = Set(views.map { $0.accessibilityIdentifier ?? "" })
            if viewsSet != viewsNames {
                result = false
            }
        } else {
            XCTAssert(false)
        }
        XCTAssert(result)
    }
}
