import XCTest

extension CapitalUITests {
    private enum AccountType: Int, CaseIterable {
        case asset, liability, revenue, expense, capital

        internal static let all = ["asset", "liability", "revenue", "expense", "capital"]
        var name: String { return AccountType.all[self.rawValue] }
    }
}

// extension Date {
//    internal var month: Int? { return Calendar.current.dateComponents([.month], from: self).month }
//    internal var day: Int? { return Calendar.current.dateComponents([.day], from: self).day }
//    internal var year: Int? { return Calendar.current.dateComponents([.year], from: self).year }
//    //    var day: Int
// }

internal class CapitalUITests: XCTestCase {
    private let app = XCUIApplication()
    private let login =
    "\(String((0..<6).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement() ?? "x" }))@gmail.com"
    private let password = String((0..<6).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement() ?? "x" })

    override internal func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override internal func tearDown() {
        super.tearDown()
        Springboard.deleteMyApp()
    }

    internal func testSignIn() {
        if app.navigationBars["DashBoard"].exists {
            XCTAssert(signOut())
        }
        XCTAssert(signUp(login: login, password: password))
        XCTAssert(signOut())
        XCTAssert(signIn(login: login, password: password))
        XCTAssert(deleteUser())
    }

    internal func testSignUp() {
        if app.navigationBars["DashBoard"].exists {
            XCTAssert(signOut())
        }
        XCTAssert(signUp(login: login, password: password))
        XCTAssert(deleteUser())
    }

    private func signUp(login: String, password: String) -> Bool {
        app.textFields["loginTextField"].tap()
        _ = login.map { app.keys[String($0)].tap() }
        app.secureTextFields["passwordTextField"].tap()
        _ = password.map { app.keys[String($0)].tap() }
        app.buttons["signUpButton"].tap()
        return app.navigationBars["DashBoard"].waitForExistence(timeout: 10)
    }

    private func signIn(login: String, password: String) -> Bool {
        app.textFields["loginTextField"].tap()
        _ = login.map { app.keys[String($0)].tap() }
        app.secureTextFields["passwordTextField"].tap()
        _ = password.map { app.keys[String($0)].tap() }
        app.buttons["signInButton"].tap()
        return app.navigationBars["DashBoard"].waitForExistence(timeout: 10)
    }

    private func signOut() -> Bool {
        app.tabBars.buttons["Settings"].tap()
        app.tables["v"].staticTexts["Log Out"].tap()
        return app.staticTexts["appTitle"].waitForExistence(timeout: 10)
    }

    private func deleteUser() -> Bool {
        app.tabBars.buttons["Settings"].tap()
        app.tables["v"].staticTexts["Delete User"].tap()
        return app.staticTexts["appTitle"].waitForExistence(timeout: 10)
    }

    private func create(account: (name: String, type: String, amount: String)) -> Bool {
        app.tabBars.buttons["Accounts"].tap()
        app.buttons[account.type].tap()
        app.navigationBars["Accounts"].buttons["New"].tap()
        app.textFields["an"].tap()
        _ = account.name.map { app.keys[String($0)].tap() }
        app.textFields["aa"].tap()
        _ = account.amount.map { app.keys[String($0)].tap() }
        app.navigationBars["New account"].buttons["Done"].tap()
        // Alternative way to call
//        let myTable = app.tables.matching(identifier: "t")
//        let cell = myTable.cells.element(matching: .cell, identifier: name)
//        cell.tap()
        return app.tables["t"].staticTexts[
            "\(account.amount) (\(account.amount))"].waitForExistence(timeout: 10)
        // FIXME: change to unique name
    }

    internal func testCreateAccount() {
        if app.navigationBars["DashBoard"].exists {
            XCTAssert(signOut())
        }
        XCTAssert(signUp(login: login, password: password))
        XCTAssert(create(account: randomAccount()))
        XCTAssert(deleteUser())
    }

    private func randomAccount() -> (name: String, type: String, amount: String) {
        return (name: String((0..<6).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! }),
                type: ["asset", "liability", "revenue", "expense"].randomElement()!,
                amount: String((0..<3).map { _ in "123456789".randomElement()! }))
    }

    internal func testCreateAccountGroup() {
        if app.navigationBars["DashBoard"].exists {
            XCTAssert(signOut())
        }
        let accounts = [randomAccount(), randomAccount()]
        let name = String((0..<6).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! })
        XCTAssert(signUp(login: login, password: password))
        _ = accounts.map { XCTAssert(create(account: $0)) }
        XCTAssert(create(accountGroup: name, with: accounts))
        XCTAssert(deleteUser())
    }

    private func create(
        accountGroup name: String,
        with accounts: [(name: String, type: String, amount: String)]
        ) -> Bool {
        app.tabBars.buttons["DashBoard"].tap()
        app.navigationBars["DashBoard"].buttons["New"].tap()
        app.textFields["nm"].tap()
        _ = name.map { app.keys[String($0)].tap() }
        _ = [0, 1].map {
            app.buttons[accounts[$0].type].tap()
            app.tables["tbl"].staticTexts[accounts[$0].name].tap()
        }
//        app.buttons["liability"].tap()
//        app.tables["tbl"].staticTexts["a"].staticTexts["b"].tap()
        app.navigationBars["DashBoard"].buttons["Done"].tap()
        return app.tables["v"].staticTexts[name].waitForExistence(timeout: 10)
//        app.tables["v"].staticTexts[name].tap()
//        sleep(10)
//        app.navigationBars["test"].buttons["DashBoard"].tap()
//        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
    }

    internal func testSimpleTransaction() {
        if app.navigationBars["DashBoard"].exists {
            XCTAssert(signOut())
        }
        let accounts = [randomAccount(), randomAccount()]
        let amount = String((0..<3).map { _ in "123456789".randomElement()! })

        XCTAssert(signUp(login: login, password: password))
        _ = accounts.map { XCTAssert(create(account: $0)) }
        XCTAssert(create(transaction: amount, with: accounts))
        XCTAssert(deleteUser())
    }

    private func create(
        transaction amount: String,
        with accounts: [(name: String, type: String, amount: String)]
        ) -> Bool {
        print("create function without date")
        app.tabBars.buttons["New Transaction"].tap()
        app.tables["v"].staticTexts["from"].tap()
        app.buttons[accounts[0].type].tap()
        app.tables["t"].staticTexts[accounts[0].name].tap()
        app.tables["v"].staticTexts["to"].tap()
        app.buttons[accounts[1].type].tap()
        app.tables["t"].staticTexts[accounts[1].name].tap()
        app.tables["v"].staticTexts["amount"].tap()
        _ = amount.map { app.keys[String($0)].tap() }
        app.navigationBars["New Transaction"].buttons["Done"].tap()
        app.tabBars.buttons["Accounts"].tap()
        app.buttons[accounts[0].type].tap()

        let newFromAccountValue =
            String((accounts[0].type == "asset" || accounts[0].type == "expense") ?
                Int(accounts[0].amount)! - Int(amount)! :
                Int(accounts[0].amount)! + Int(amount)!)
        print("LOG accounts[0].type \(accounts[0].type)")
        print((accounts[0].type == "asset" || accounts[0].type == "expense"))
        print("LOG newFromAccountValue \(newFromAccountValue)")

        let newToAccountValue =
            String((accounts[1].type == "asset" || accounts[1].type == "expense") ?
                Int(accounts[1].amount)! + Int(amount)! :
                Int(accounts[1].amount)! - Int(amount)!)
        print("LOG accounts[1].type \(accounts[1].type)")
        print((accounts[1].type == "asset" || accounts[1].type == "expense"))
        print("LOG newToAccountValue \(newToAccountValue)")

        let fromAccountIsCorrect = app.tables["t"].staticTexts[
            "\(newFromAccountValue) (\(newFromAccountValue))"].waitForExistence(timeout: 10)
        app.buttons[accounts[1].type].tap()
        let toAccountIsCorrect = app.tables["t"].staticTexts[
            "\(newToAccountValue) (\(newToAccountValue))"].waitForExistence(timeout: 10)
        return fromAccountIsCorrect && toAccountIsCorrect
    }

    private func create(
        transaction amount: String,
        with accounts: [(name: String, type: String, amount: String)],
        onDate date: Date
        ) -> Bool {
        app.tabBars.buttons["New Transaction"].tap()
        app.tables["v"].staticTexts["from"].tap()
        app.buttons[accounts[0].type].tap()
        app.tables["t"].staticTexts[accounts[0].name].tap()
        app.tables["v"].staticTexts["to"].tap()
        app.buttons[accounts[1].type].tap()
        app.tables["t"].staticTexts[accounts[1].name].tap()
        app.tables["v"].staticTexts["amount"].tap()
        _ = amount.map { app.keys[String($0)].tap() }
        app.tables["v"].staticTexts["date"].tap()

//        let datePickers = app.datePickers
//        datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "June")
//        _ = app.tables["v"].datePickers["v"].waitForExistence(timeout: 10)
//        print(app.descendants(matching: .any).debugDescription)
//        datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: date.day)
//        app.tables["v"].datePickers["v"].pickerWheels.element(
//        boundBy: 1).adjust(toPickerWheelValue: date.day)
//        datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2015")
//        print("transaction date \(date.day ?? 0)")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "\(date.day ?? 0)")
        app.navigationBars["New Transaction"].buttons["Done"].tap()
        app.tabBars.buttons["Accounts"].tap()

        app.buttons[accounts[0].type].tap()
        let newFromAccountValue: String =
            String((accounts[0].type == "asset" || accounts[0].type == "expense") ?
                Int(accounts[0].amount)! - Int(amount)! :
                Int(accounts[0].amount)! + Int(amount)!)
        print("accounts[0].type \(accounts[0].type)")
        print((accounts[0].type == "asset" || accounts[0].type == "expense"))
        print("newFromAccountValue \(newFromAccountValue)")
        let fromAccountIsCorrect =
            app.tables["t"].staticTexts[
                "\(newFromAccountValue) (\(newFromAccountValue))"].waitForExistence(timeout: 10)

        app.buttons[accounts[1].type].tap()
        let newToAccountValue =
            String((accounts[1].type == "asset" || accounts[1].type == "expense") ?
                Int(accounts[1].amount)! + Int(amount)! :
                Int(accounts[1].amount)! - Int(amount)!)
        print("accounts[1].type \(accounts[1].type)")
        print((accounts[1].type == "asset" || accounts[1].type == "expense"))
        print("newToAccountValue \(newToAccountValue)")

        let toAccountIsCorrect =
            app.tables["t"].staticTexts[
                "\(newToAccountValue) (\(newToAccountValue))"].waitForExistence(timeout: 10)

        return fromAccountIsCorrect && toAccountIsCorrect
    }

//    func testTransactionNotToday() {
//        if app.navigationBars["DashBoard"].exists {XCTAssert(signOut())}
//        let accounts = [randomAccount(), randomAccount()]
//        let amount = String((0..<3).map{ _ in "123456789".randomElement()! })
//        let day = "15"//(1...27).map{String($0)}.randomElement()!
//        let month = "December"
//        let year = "2018"
//        let date = (day: day, month: "December", year: "2018")
//        let sampleDate = "\(day)-\(month)-\(year)".date(withFormat: "dd-MMMM-yyyy")
//        print(sampleDate?.str as Any)
//        print(Date().str)
//        XCTAssert(signUp(login: login, password: password))
//        _ = accounts.map{XCTAssert(create(account: $0))}
//        XCTAssert(create(transaction: amount, with: accounts, onDate: sampleDate!))
//        XCTAssert(deleteUser())
//
//        let vTable = app.tables["v"]
//        vTable.staticTexts["2018 Dec-21"].tap()
//        vTable.pickerWheels["21"].press(forDuration: 1.2);
//        vTable.pickerWheels["20"].press(forDuration: 0.8);
//        vTable.staticTexts["repeat"].tap()
//        vTable.staticTexts["Every Day"].tap()
//
//        let vTable = app.tables["v"]
//        vTable.pickerWheels["19"].swipeUp()
//        vTable.pickerWheels["22"].press(forDuration: 1.0);
//        vTable.pickerWheels["23"].press(forDuration: 0.5);
//
//    }
}
