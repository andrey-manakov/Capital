
import XCTest

extension CapitalUITests {
    private enum AccountType: Int, CaseIterable {
        case asset, liability, revenue, expense, capital
        static let all = ["asset", "liability", "revenue", "expense", "capital"]
        var name: String {return AccountType.all[self.rawValue]}
    }
}

class CapitalUITests: XCTestCase {
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
    
    func create(account: (name: String, type: String, amount: String)) -> Bool {
        app.tabBars.buttons["Accounts"].tap()
        app.buttons[account.type].tap()
        app.navigationBars["Accounts"].buttons["New"].tap()
        app/*@START_MENU_TOKEN@*/.textFields["an"]/*[[".textFields[\"new account name\"]",".textFields[\"an\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        _ = account.name.map{app.keys[String($0)].tap()}
        app/*@START_MENU_TOKEN@*/.textFields["aa"]/*[[".textFields[\"initial account amount\"]",".textFields[\"aa\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        _ = account.amount.map{app.keys[String($0)].tap()}
        app.navigationBars["New account"].buttons["Done"].tap()
        //Alternative way to call
//        let myTable = app.tables.matching(identifier: "t")
//        let cell = myTable.cells.element(matching: .cell, identifier: name)
//        cell.tap()
        return app.tables["t"].staticTexts["\(account.amount) (\(account.amount))"].waitForExistence(timeout: 10) // FIXME: change to unique name
    }
    
    func testCreateAccount() {
        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
        XCTAssert(signUp(login: login, password: password))
        XCTAssert(create(account: randomAccount()))
        XCTAssert(deleteUser())
    }
    
    func randomAccount() -> (name: String, type: String, amount: String) {
        return (name: String((0..<6).map{ _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! }),
                type: ["asset", "liability", "revenue", "expense"].randomElement()!,
                amount: String((0..<3).map{ _ in "123456789".randomElement()! }))
    }
    
    func testCreateAccountGroup() {
        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
        let accounts = [randomAccount(), randomAccount()]
        let name = String((0..<6).map{ _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! })
        XCTAssert(signUp(login: login, password: password))
        _ = accounts.map{XCTAssert(create(account: $0))}
        XCTAssert(create(accountGroup: name, with: accounts))
        XCTAssert(deleteUser())
    }
    
    func create(accountGroup name: String, with accounts: [(name: String, type: String, amount: String)]) -> Bool {
        
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
    
//    func testSimpleTransaction() {
//        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
//        let accounts = [randomAccount(), randomAccount()]
//        let amount = String((0..<3).map{ _ in "123456789".randomElement()! })
//
//        XCTAssert(signUp(login: login, password: password))
//        _ = accounts.map{XCTAssert(create(account: $0))}
//        XCTAssert(create(transaction: amount, with: accounts))
//        XCTAssert(deleteUser())
//    }
    
    func create(transaction amount: String, with accounts: [(name: String, type: String, amount: String)]) -> Bool {
        app.tabBars.buttons["New Transaction"].tap()
        app.tables["v"]/*@START_MENU_TOKEN@*/.staticTexts["from"]/*[[".cells.staticTexts[\"from\"]",".staticTexts[\"from\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons[accounts[0].type].tap()
        app.tables["t"].staticTexts[accounts[0].name].tap()
        app.tables["v"].staticTexts["to"].tap()
        app.buttons[accounts[1].type].tap()
        app.tables["t"].staticTexts[accounts[1].name].tap()
        app.tables["v"]/*@START_MENU_TOKEN@*/.staticTexts["amount"]/*[[".cells.staticTexts[\"amount\"]",".staticTexts[\"amount\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        _ = amount.map{app.keys[String($0)].tap()}
        app.navigationBars["New Transaction"].buttons["Done"].tap()
        app.tabBars.buttons["Accounts"].tap()
        app.buttons[accounts[0].type].tap()
        let newFromAccountValue = String((accounts[0].type == "asset" || accounts[0].type == "expense") ? Int(accounts[0].amount)! - Int(amount)!: Int(accounts[0].amount)! + Int(amount)!)
        let newToAccountValue = String((accounts[1].type == "asset" || accounts[1].type == "expense") ? Int(accounts[1].amount)! + Int(amount)!: Int(accounts[1].amount)! - Int(amount)!)

        let fromAccountIsCorrect = app.tables["t"].staticTexts["\(newFromAccountValue) (\(newFromAccountValue))"].waitForExistence(timeout: 10)
        app.buttons[accounts[1].type].tap()
        let toAccountIsCorrect = app.tables["t"].staticTexts["\(newToAccountValue) (\(newToAccountValue))"].waitForExistence(timeout: 10)
        return fromAccountIsCorrect && toAccountIsCorrect
    }
    
    func create(transaction amount: String, with accounts: [(name: String, type: String, amount: String)], onDate date: Date) -> Bool {
        app.tabBars.buttons["New Transaction"].tap()
        app.tables["v"]/*@START_MENU_TOKEN@*/.staticTexts["from"]/*[[".cells.staticTexts[\"from\"]",".staticTexts[\"from\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons[accounts[0].type].tap()
        app.tables["t"].staticTexts[accounts[0].name].tap()
        app.tables["v"].staticTexts["to"].tap()
        app.buttons[accounts[1].type].tap()
        app.tables["t"].staticTexts[accounts[1].name].tap()
        app.tables["v"]/*@START_MENU_TOKEN@*/.staticTexts["amount"]/*[[".cells.staticTexts[\"amount\"]",".staticTexts[\"amount\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        _ = amount.map{app.keys[String($0)].tap()}
        
        app.tables["v"].staticTexts["date"].tap()

//        let datePickers = app.datePickers
//        datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "June")
//        _ = app.tables["v"].datePickers["v"].waitForExistence(timeout: 10)
//        print(app.descendants(matching: .any).debugDescription)
//        datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: date.day)
//        app.tables["v"].datePickers["v"].pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: date.day)
//        datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2015")
        print("transaction date \(date.day)")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "\(date.day)")
        
        app.navigationBars["New Transaction"].buttons["Done"].tap()
        app.tabBars.buttons["Accounts"].tap()

        app.buttons[accounts[0].type].tap()
        let newFromAccountValue = String((accounts[0].type == "asset" || accounts[0].type == "expense") ? Int(accounts[0].amount)! - Int(amount)!: Int(accounts[0].amount)! + Int(amount)!)
        let fromAccountIsCorrect = app.tables["t"].staticTexts["\(newFromAccountValue) (\(newFromAccountValue))"].waitForExistence(timeout: 10)

        app.buttons[accounts[1].type].tap()
        let newToAccountValue = String((accounts[1].type == "asset" || accounts[1].type == "expense") ? Int(accounts[1].amount)! + Int(amount)!: Int(accounts[1].amount)! - Int(amount)!)
        let toAccountIsCorrect = app.tables["t"].staticTexts["\(newToAccountValue) (\(newToAccountValue))"].waitForExistence(timeout: 10)

        return fromAccountIsCorrect && toAccountIsCorrect
    }
    
//    func testTransactionNotToday() {
//        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
//        let accounts = [randomAccount(), randomAccount()]
//        let amount = String((0..<3).map{ _ in "123456789".randomElement()! })
//        let day = "15"//(1...27).map{String($0)}.randomElement()!
//        let month = "December"
//        let year = "2018"
////        let date = (day: day, month: "December", year: "2018")
//        let sampleDate = "\(day)-\(month)-\(year)".date(withFormat: "dd-MMMM-yyyy")
//        print(sampleDate?.str as Any)
//        print(Date().str)
//        XCTAssert(signUp(login: login, password: password))
//        _ = accounts.map{XCTAssert(create(account: $0))}
//        XCTAssert(create(transaction: amount, with: accounts, onDate: sampleDate!))
//        XCTAssert(deleteUser())
//        
////        let vTable = app.tables["v"]
////        vTable/*@START_MENU_TOKEN@*/.staticTexts["2018 Dec-21"]/*[[".cells.staticTexts[\"2018 Dec-21\"]",".staticTexts[\"2018 Dec-21\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
////        vTable/*@START_MENU_TOKEN@*/.pickerWheels["21"].press(forDuration: 1.2);/*[[".cells.pickerWheels[\"21\"]",".tap()",".press(forDuration: 1.2);",".pickerWheels[\"21\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
////        vTable/*@START_MENU_TOKEN@*/.pickerWheels["20"].press(forDuration: 0.8);/*[[".cells.pickerWheels[\"20\"]",".tap()",".press(forDuration: 0.8);",".pickerWheels[\"20\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
////        vTable/*@START_MENU_TOKEN@*/.staticTexts["repeat"]/*[[".cells.staticTexts[\"repeat\"]",".staticTexts[\"repeat\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
////        vTable/*@START_MENU_TOKEN@*/.staticTexts["Every Day"]/*[[".cells[\"Every Day\"].staticTexts[\"Every Day\"]",".staticTexts[\"Every Day\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
////
////        let vTable = app.tables["v"]
////        vTable/*@START_MENU_TOKEN@*/.pickerWheels["19"]/*[[".cells.pickerWheels[\"19\"]",".pickerWheels[\"19\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
////        vTable/*@START_MENU_TOKEN@*/.pickerWheels["22"].press(forDuration: 1.0);/*[[".cells.pickerWheels[\"22\"]",".tap()",".press(forDuration: 1.0);",".pickerWheels[\"22\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
////        vTable/*@START_MENU_TOKEN@*/.pickerWheels["23"].press(forDuration: 0.5);/*[[".cells.pickerWheels[\"23\"]",".tap()",".press(forDuration: 0.5);",".pickerWheels[\"23\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
//        
//    }
    

}
