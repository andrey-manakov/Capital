@testable import Capital
import XCTest

internal class AccountTests: XCTestCase {
    /// <#Description#>
    internal func testInitWithData() {
        // 1. Arrange
        let data = ["name": "name"]

        // 2. Action
        let account = Account(data)

        // 3. Assert
        let rightAccount = Account()
        rightAccount.name = "name"
        XCTAssertEqual(account, rightAccount)
    }

    /// <#Description#>
    internal func testUpdateWithNameFieldValue() {
        // 1. Arrange
        let field = "name"
        let value = "name"
        let account = Account()

        // 2. Action
        account.update(field: field, value: value)

        // 3. Assert
        let rightAccount = Account()
        rightAccount.name = "name"
        XCTAssertEqual(account, rightAccount)
    }

    /// <#Description#>
    internal func testUpdateWithAmountFieldValue() {
        // 1. Arrange
        let field = "amount"
        let value = 10
        let account = Account()

        // 2. Action
        account.update(field: field, value: value)

        // 3. Assert
        let rightAccount = Account()
        rightAccount.amount = 10
        XCTAssertEqual(account, rightAccount)
    }

    /// <#Description#>
    internal func testUpdateWithTypeFieldValue() {
        // 1. Arrange
        let field = "type"
        let value = 0
        let account = Account()

        // 2. Action
        account.update(field: field, value: value)

        // 3. Assert
        let rightAccount = Account()
        rightAccount.typeId = 0
        XCTAssertEqual(account, rightAccount)
    }

    /// <#Description#>
    internal func testUpdateWithGroupsFieldValue() {
        // 1. Arrange
        let field = "groups"
        let value = ["group id": "group name"]
        let account = Account()

        // 2. Action
        account.update(field: field, value: value)

        // 3. Assert
        let rightAccount = Account()
        rightAccount.groups = ["group id": "group name"]
        XCTAssertEqual(account, rightAccount)
    }

    /// <#Description#>
    internal func testUpdateWithMinFieldValue() {
        // 1. Arrange
        let field = "min"
        let minDate = Date()
        let value: [String: Any] = ["amount": 10, "date": Timestamp(date: minDate)]
        let account = Account()

        // 2. Action
        account.update(field: field, value: value)

        // 3. Assert
        let rightAccount = Account()
        rightAccount.minAmount = 10
        rightAccount.minDate = minDate
        XCTAssertEqual(account, rightAccount)
    }

    /// <#Description#>
    internal func testUpdateWithWrongFieldName() {
        // 1. Arrange
        let field = "wrong field name"
        let value = 0
        let account = Account()

        // 2. Action
        account.update(field: field, value: value)

        // 3. Assert
        let rightAccount = Account()
        XCTAssertEqual(account, rightAccount)
    }

    /// <#Description#>
    internal func testUpdateWithWrongMinFieldName() {
        // 1. Arrange
        let field = "min"
        let value: [String: Any] = [:]
        let account = Account()

        // 2. Action
        account.update(field: field, value: value)

        // 3. Assert
        let rightAccount = Account()
        XCTAssertEqual(account, rightAccount)
    }
}
