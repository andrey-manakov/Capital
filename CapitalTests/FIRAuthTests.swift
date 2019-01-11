@testable import Capital
import XCTest

internal final class FIRAuthTests: XCTestCase {
    private var sut: FireAuthProtocol!
    private let login =
    "\(String((0..<6).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! }))@gmail.com"
    private let password = String((0..<6).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! })

    override internal func setUp() {
        super.setUp()
        sut = FIRAuth.shared
    }

    override internal func tearDown() {
        self.sut = nil
        super.tearDown()
    }

    internal func testSignUp() {
        // given
        let promise = expectation(description: "Completion handler invoked")
        var responseError: Error?

        // when
        sut.createUser(withEmail: login, password: password) { error in
            responseError = error
            XCTAssert(self.sut.currentUserUid != nil)
            self.sut.deleteUser { error in
                responseError = responseError ?? error
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                XCTAssert(self.sut.currentUserUid == nil)
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssertNil(responseError)
    }

    internal func testSignIn() {
        // given
        let promise = expectation(description: "Completion handler invoked")
        var responseError: Error?

        // when
        sut.createUser(withEmail: login, password: password) { error in
            responseError = error
            XCTAssert(self.sut.currentUserUid != nil)
            self.sut.signOutUser { error in
                responseError = responseError ?? error
                XCTAssert(self.sut.currentUserUid == nil)

                self.sut.signInUser(withEmail: self.login, password: self.password) { error in
                    responseError = responseError ?? error
                    XCTAssert(self.sut.currentUserUid != nil)

                    self.sut.deleteUser { error in
                        responseError = responseError ?? error
                        if let error = error {
                            fatalError(error.localizedDescription)
                        }
                        XCTAssert(self.sut.currentUserUid == nil)
                        promise.fulfill()
                    }
                }
            }
        }
        waitForExpectations(timeout: 10, handler: nil)

        // then
        XCTAssertNil(responseError)
    }
}
