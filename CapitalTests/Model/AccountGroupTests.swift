@testable import Capital
import XCTest

internal final class AccountGroupTests: XCTestCase {
    /// Test checks that object is correctly initialized with dictionary of [field: value]
    internal func testInitWithData() {
        // 1. Arrange
        let data = ["name": "name"]

        // 2. Action
        let sample = Account.Group(data)

        // 3. Assert
        let master = Account.Group()
        master.name = "name"
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates name, when ["name": "some name"] is submitted
    internal func testUpdateWithNameFieldValue() {
        // 1. Arrange
        let field = "name"
        let value = "name"
        let sample = Account.Group()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = Account.Group()
        master.name = "name"
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates amount, when ["amount": 10] is submitted
    internal func testUpdateWithAmountFieldValue() {
        // 1. Arrange
        let field = "amount"
        let value = 10
        let sample = Account.Group()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = Account.Group()
        master.amount = 10
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates groups,
    /// when ["groups": ["group id": "group name"]]] is submitted
    internal func testUpdateWithGroupsFieldValue() {
        // 1. Arrange
        let field = "accounts"
        let value = ["account id": "account name"]
        let sample = Account.Group()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = Account.Group()
        master.accounts = ["account id": "account name"]
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates min value and date,
    /// when ["min" : ["amount": 10, "date": {timestamp}]] is submitted
    internal func testUpdateWithMinFieldValue() {
        // 1. Arrange
        let field = "min"
        let minDate = Date()
        let value: [String: Any] = ["amount": 10, "date": Timestamp(date: minDate)]
        let sample = Account.Group()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = Account.Group()
        master.min = (10, minDate)
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly doesn't change object, when some wrong field is submitted
    internal func testUpdateWithWrongFieldName() {
        // 1. Arrange
        let field = "wrong field name"
        let value = 0
        let sample = Account.Group()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = Account.Group()
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly doesn't change object, when wrong min field is submitted
    internal func testUpdateWithWrongMinFieldName() {
        // 1. Arrange
        let field = "min"
        let value: [String: Any] = [:]
        let sample = Account.Group()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = Account.Group()
        XCTAssertEqual(master, sample)
    }
}
