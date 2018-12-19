import XCTest
@testable import Capital

class FIRAuthTests: XCTestCase {
    
    var sut: FireAuthProtocol!
    
    override func setUp(){
        super.setUp()
        sut = FIRAuth.shared
    }
    
    override func tearDown()
    {
        sut = nil
        super.tearDown()
    }
    
    
    func testSignUp() {
        
        // given
        let promise = expectation(description: "Completion handler invoked")
        var responseError: Error?
        let email = "\(String.randomWithSmallLetters())@gmail.com"

        // when
        sut.createUser(withEmail: email, password: "c0mp1!c@ted.password") {error in
            print("LOG user created with id \(Auth.auth().currentUser?.uid ?? "")")
            responseError = error
            self.sut.deleteUser { error in promise.fulfill()}
        }
        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertNil(responseError)
    }

    func testSignIn() {
        
        // given
        let promise = expectation(description: "Completion handler invoked")
        var errorDesc: String? = nil
        var responseError: Error? = nil {didSet {errorDesc = responseError?.localizedDescription}}

        
        // when
        sut.createUser(withEmail: "test@gmail.com", password: "c0mp1!c@ted.password") {error in
            if let error = error {responseError = error}
            self.sut.signInUser(withEmail: "test@gmail.com", password: "c0mp1!c@ted.password") {error in
                if let error = error {responseError = error}
                if Auth.auth().currentUser == nil {errorDesc = "User is nil"}
                responseError = error
                self.sut.deleteUser { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    promise.fulfill()}
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(errorDesc)
    }

//    func testSignOut() {
//
//        // given
//        let promise = expectation(description: "Completion handler invoked")
//        var errorDesc: String? = nil
//        var responseError: Error? = nil {didSet {errorDesc = responseError?.localizedDescription}}
//
//
//        // when
//        sut.createUser(withEmail: "test@gmail.com", password: "c0mp1!c@ted.password") {error in
//            if let error = error {responseError = error}
//            self.sut.signInUser(withEmail: "test@gmail.com", password: "c0mp1!c@ted.password") {error in
//                if let error = error {responseError = error}
//
//
////                self.sut.deleteUser { error in promise.fulfill()}
//            }
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//
//        // then
//        XCTAssertNil(errorDesc)
//    }
    
}

