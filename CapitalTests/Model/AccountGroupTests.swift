@testable import Capital
import XCTest

internal final class AccountGroupTests: XCTestCase {
    /// Test checks that object is correctly initialized with dictionary of [field: value]
    internal func testInitWithData() {
        // 1. Arrange
        let data = ["name": "name"]

        // 2. Action
        let sample = AccountGroup(data)

        // 3. Assert
        let master = AccountGroup()
        master.name = "name"
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates name, when ["name": "some name"] is submitted
    internal func testUpdateWithNameFieldValue() {
        // 1. Arrange
        let field = "name"
        let value = "name"
        let sample = AccountGroup()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = AccountGroup()
        master.name = "name"
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates amount, when ["amount": 10] is submitted
    internal func testUpdateWithAmountFieldValue() {
        // 1. Arrange
        let field = "amount"
        let value = 10
        let sample = AccountGroup()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = AccountGroup()
        master.amount = 10
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates groups,
    /// when ["groups": ["group id": "group name"]]] is submitted
    internal func testUpdateWithGroupsFieldValue() {
        // 1. Arrange
        let field = "accounts"
        let value = ["account id": "account name"]
        let sample = AccountGroup()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = AccountGroup()
        master.accounts = ["account id": "account name"]
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates min value and date, when ["min" : ["amount": 10, "date": {timestamp}]] is submitted
    internal func testUpdateWithMinAmountFieldValue() {
        // 1. Arrange
        let field = "minAmount"
        let value: [String: Any] = ["amount": 10]
        let sample = AccountGroup()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = AccountGroup()
        master.minAmount = 10
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates min value and date, when ["min" : ["amount": 10, "date": {timestamp}]] is submitted
    internal func testUpdateWithMinDateFieldValue() {
        // 1. Arrange
        let field = "minDate"
        let minDate = Date()
        let value: [String: Any] = ["date": Timestamp(date: minDate)]
        let sample = AccountGroup()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = AccountGroup()
        master.minDate = minDate
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly doesn't change object, when some wrong field is submitted
    internal func testUpdateWithWrongFieldName() {
        // 1. Arrange
        let field = "wrong field name"
        let value = 0
        let sample = AccountGroup()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = AccountGroup()
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly doesn't change object, when wrong min field is submitted
    internal func testUpdateWithWrongMinFieldName() {
        // 1. Arrange
        let field = "min"
        let value: [String: Any] = [:]
        let sample = AccountGroup()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = AccountGroup()
        XCTAssertEqual(master, sample)
    }
}
