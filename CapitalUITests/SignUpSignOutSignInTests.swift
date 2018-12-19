
import XCTest

class SignUpSignOutSignInTests: XCTestCase {
    let app = XCUIApplication()
    let login = "\(String((0..<6).map{ _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! }))@gmail.com"
    let password = String((0..<6).map{ _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! })

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        Springboard.deleteMyApp()
    }

    func testSignIn() {
        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
        XCTAssert(signUp(login: login, password: password))
        XCTAssert(signOut())
        XCTAssert(signIn(login: login, password: password))
        XCTAssert(deleteUser())
    }

    func testSignUp() {
        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
        XCTAssert(signUp(login: login, password: password))
        XCTAssert(deleteUser())
    }

    func signUp(login: String, password: String)->Bool {
        app.textFields["loginTextField"].tap()
        _ = login.map{app.keys[String($0)].tap()}
        app/*@START_MENU_TOKEN@*/.secureTextFields["passwordTextField"]/*[[".secureTextFields[\"password\"]",".secureTextFields[\"passwordTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        _ = password.map{app.keys[String($0)].tap()}
        app/*@START_MENU_TOKEN@*/.buttons["signUpButton"]/*[[".buttons[\"Sign Up\"]",".buttons[\"signUpButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        return app.navigationBars["DashBoard"].waitForExistence(timeout: 10)
    }
    
    func signIn(login: String, password: String)->Bool {
        app.textFields["loginTextField"].tap()
        _ = login.map{app.keys[String($0)].tap()}
        app/*@START_MENU_TOKEN@*/.secureTextFields["passwordTextField"]/*[[".secureTextFields[\"password\"]",".secureTextFields[\"passwordTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        _ = password.map{app.keys[String($0)].tap()}
        app.buttons["signInButton"].tap()
        return app.navigationBars["DashBoard"].waitForExistence(timeout: 10)
    }
    
    func signOut()->Bool {
        app.tabBars.buttons["Settings"].tap()
        app.tables["v"].staticTexts["Log Out"].tap()
        return app.staticTexts["appTitle"].waitForExistence(timeout: 10)
    }

    func deleteUser()->Bool {
        app.tabBars.buttons["Settings"].tap()
        app.tables["v"].staticTexts["Delete User"].tap()
        return app.staticTexts["appTitle"].waitForExistence(timeout: 10)
    }
    
    func createAccount(name: String, type: String = "asset", amount: String) -> Bool {
        app.tabBars.buttons["Accounts"].tap()
        app.buttons[type].tap()
        app.navigationBars["Accounts"].buttons["New"].tap()
        app/*@START_MENU_TOKEN@*/.textFields["an"]/*[[".textFields[\"new account name\"]",".textFields[\"an\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        _ = name.map{app.keys[String($0)].tap()}
        app/*@START_MENU_TOKEN@*/.textFields["aa"]/*[[".textFields[\"initial account amount\"]",".textFields[\"aa\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        _ = amount.map{app.keys[String($0)].tap()}
        app.navigationBars["New account"].buttons["Done"].tap()
        //Alternative way to call
//        let myTable = app.tables.matching(identifier: "t")
//        let cell = myTable.cells.element(matching: .cell, identifier: name)
//        cell.tap()
        return app.tables["t"].staticTexts[amount].waitForExistence(timeout: 10) // FIXME: change to unique name
    }
    
    func testCreateAccount() {
        let amount = String((0..<3).map{ _ in "123456789".randomElement()! })
        let name = String((0..<6).map{ _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! })
        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
        XCTAssert(signUp(login: login, password: password))
        XCTAssert(createAccount(name: name, amount: amount))
        XCTAssert(deleteUser())
    }
    
    func testCreateAccountGroup() {
        let name = String((0..<6).map{ _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! })
        let amount1 = String((0..<3).map{ _ in "123456789".randomElement()! })
        let name1 = String((0..<6).map{ _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! })
        let amount2 = String((0..<3).map{ _ in "123456789".randomElement()! })
        let name2 = String((0..<6).map{ _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! })
        XCTAssert(signUp(login: login, password: password))
        XCTAssert(createAccount(name: name1, type: "asset" ,amount: amount1))
        XCTAssert(createAccount(name: name2, type: "liability" ,amount: amount2))
        XCTAssert(createAccountGroup(name, with: [(type: "asset", name: name1),(type: "liability", name: name2) ]))
        XCTAssert(deleteUser())
    }
    
    func createAccountGroup(_ name: String, with accounts: [(type: String, name: String)]) -> Bool{
        
        app.tabBars.buttons["DashBoard"].tap()
        app.navigationBars["DashBoard"].buttons["New"].tap()
        app.textFields["nm"].tap()
        _ = name.map{app.keys[String($0)].tap()}
        _ = [0,1].map{
            app.buttons[accounts[$0].type].tap()
            app.tables["tbl"].staticTexts[accounts[$0].name].tap()
        }
        
//        app/*@START_MENU_TOKEN@*/.buttons["liability"]/*[[".segmentedControls[\"sc\"].buttons[\"liability\"]",".buttons[\"liability\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.tables["tbl"]/*@START_MENU_TOKEN@*/.staticTexts["a"]/*[[".cells[\"a\"].staticTexts[\"a\"]",".staticTexts[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*//*@START_MENU_TOKEN@*/.staticTexts["b"]/*[[".cells[\"b\"].staticTexts[\"b\"]",".staticTexts[\"b\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["DashBoard"].buttons["Done"].tap()
        return app.tables["v"].staticTexts[name].waitForExistence(timeout: 10)
//        app.tables["v"].staticTexts[name].tap()
//        sleep(10)
//        app.navigationBars["test"].buttons["DashBoard"].tap()
//        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
    }


}
