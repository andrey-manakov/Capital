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
    private static var app: XCUIApplication?
    private lazy var app: XCUIApplication = CapitalUITests.app ?? XCUIApplication() // TODO: Refactor
    private let login =
    "\(String((0..<6).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement() ?? "x" }))@gmail.com"
    private let password = String((0..<6).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement() ?? "x" })

    override internal func setUp() {
        super.setUp()
        continueAfterFailure = false // TODO: move to instance method
//        guard CapitalUITests.app == nil else {
//            return
//        }
//        app = XCUIApplication()
        CapitalUITests.app = XCUIApplication()
        CapitalUITests.app?.launch()
        if app.navigationBars["DashBoard"].exists {
            XCTAssert(signOut())
        }
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
        let testResult = app.navigationBars["DashBoard"].waitForExistence(timeout: 10)
        print("Test result signUp \(testResult)")
        return testResult
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
        let testResult = app.staticTexts["appTitle"].waitForExistence(timeout: 10)
        print("Test result signOut \(testResult)")
        return testResult
    }

    private func deleteUser() -> Bool {
        app.tabBars.buttons["Settings"].tap()
        app.tables["v"].staticTexts["Delete User"].tap()
        let testResult = app.staticTexts["appTitle"].waitForExistence(timeout: 10)
        print("Test result deleteUser \(testResult)")
        return testResult
    }

    private func create(account: (name: String, type: String, amount: Int)) -> Bool {
        app.tabBars.buttons["Accounts"].tap()
        app.buttons[account.type].tap()
        app.navigationBars["Accounts"].buttons["New"].tap()
        app.textFields["an"].tap()
        _ = account.name.map { app.keys[String($0)].tap() }
        app.textFields["aa"].tap()
        _ = "\(account.amount)".map { app.keys[String($0)].tap() }
        app.navigationBars["New account"].buttons["Done"].tap()
        // Alternative way to call
//        let myTable = app.tables.matching(identifier: "t")
//        let cell = myTable.cells.element(matching: .cell, identifier: name)
//        cell.tap()
        let testResult = app.tables["t"].staticTexts[
            "\(account.amount) (\(account.amount))"].waitForExistence(timeout: 10)
        print("Test result create account \(testResult)")
        return testResult
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

    private func randomAccount() -> (name: String, type: String, amount: Int) {
        return (name: String((0..<6).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! }),
                type: ["asset", "liability", "revenue", "expense"].randomElement()!,
                amount: Int.random(in: 0 ..< 1_000))
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
        with accounts: [(name: String, type: String, amount: Int)]
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
        with accounts: [(name: String, type: String, amount: Int)]
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
                accounts[0].amount - Int(amount)! :
                accounts[0].amount + Int(amount)!)
        print("LOG accounts[0].type \(accounts[0].type)")
        print((accounts[0].type == "asset" || accounts[0].type == "expense"))
        print("LOG newFromAccountValue \(newFromAccountValue)")

        let newToAccountValue =
            String((accounts[1].type == "asset" || accounts[1].type == "expense") ?
                accounts[1].amount + Int(amount)! :
                accounts[1].amount - Int(amount)!)
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
        transaction amount: Int,
        with accounts: [(name: String, type: String, amount: Int)],
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
        _ = "\(amount)".map { app.keys[String($0)].tap() }
        app.tables["v"].staticTexts["date"].tap()

//        print(app.descendants(matching: .any).debugDescription)

//        let datePickers = app.datePickers
//        datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "June")
//        _ = app.tables["v"].datePickers["v"].waitForExistence(timeout: 10)
//        datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: date.day)
//        app.tables["v"].datePickers["v"].pickerWheels.element(
//            boundBy: 1).adjust(toPickerWheelValue: date.day)
//        datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2015")

        print("transaction date \(date.day ?? 0)")
//        sleep(5)
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "\(date.day ?? 0)")
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "\(date.year ?? 0)")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "\(date.monthString ?? "")")
        print("Transaction date: \(date)")
        print("Current date: \(Date())")
//        sleep(5)
        app.navigationBars["New Transaction"].buttons["Done"].tap()
        app.tabBars.buttons["Accounts"].tap()

        var i = 1
        return accounts.map {
            app.buttons[$0.type].tap()
            let currentAmount: Int
            let minAccountValue: Int =
                ($0.type == "asset" || $0.type == "expense") ?
                    $0.amount - i * amount :
                    $0.amount + i * amount
            i = -1
            if date.isAfter(Date()) {
                currentAmount = $0.amount
            } else {
                currentAmount = min(minAccountValue, $0.amount)
            }
            return app.tables["t"].staticTexts[
                    "\(currentAmount) (\(minAccountValue))"].waitForExistence(timeout: 10)
        }.filter { $0 }.count == 2
    }

    private func create(transaction amount: Int, onDate date: Date) -> Bool {
        let accounts = [randomAccount(), randomAccount()]
        _ = accounts.map {
            XCTAssert(create(account: $0))
        }
        return create(transaction: amount, with: accounts, onDate: date)
    }

    private func createTransaction(_ time: Time) -> Bool {
        switch time {
        case .today:
            break

        case .future:
            break

        case .past:
            break

        case .nextYear:
            guard let date = Calendar.current.date(byAdding: .year, value: 1, to: Date()) else {
                return false
            }
            return create(transaction: Int.random(in: 0 ..< 1_000), onDate: date)
        }
        return false
    }

    enum Time {
        case today
        case future
        case past
        case nextYear
    }

    /// Tests transaction next year
    internal func testTransactionNextYear() {
        XCTAssert(createTransaction(.nextYear))
    }

    /// Tests transaction creation in the future
    internal func testTransactionNotToday() {
        if app.navigationBars["DashBoard"].exists {
            XCTAssert(signOut())
        }
        let accounts = [randomAccount(), randomAccount()]
        let amount = Int.random(in: 0 ..< 1_000)// String((0..<3).map { _ in "123456789".randomElement()! })
//        let day = (1...27).map { String($0) }.randomElement()!  // "\(Date().localDay!)"
//        let month = (1...12).map { String($0) }.randomElement()! // "\(Date().month!)"
//        let year = "2020"// "\(Date().year!)"  // [2018, 2019].map {String($0)}.randomElement()!
        let day = "\(Date().localDay!)"
        let month = "\(Date().month!)"
        let year = "2020"// "\(Date().year!)"
        let sampleDate = "\(day)-\(month)-\(year)".date(withFormat: "dd-MM-yyyy")
        XCTAssert(signUp(login: login, password: password))
        _ = accounts.map {
            XCTAssert(create(account: $0))
        }
        XCTAssert(create(transaction: amount, with: accounts, onDate: sampleDate!))
        XCTAssert(deleteUser())
    }
}
