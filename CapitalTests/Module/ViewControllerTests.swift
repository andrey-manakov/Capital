@testable import Capital
import XCTest

internal class ViewControllerTests: XCTestCase {
    // MARK: Subject under test

    private var sut: ViewController?
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
        sut = ViewController("data")
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
}
