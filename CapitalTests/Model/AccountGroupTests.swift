@testable import Capital
import XCTest

internal final class AccountGroupTests: XCTestCase {
    let master = AccountGroup()
    let sample = AccountGroup()
    /// Test that properties list of `AccountGroup` is correctly treated
    internal func testFieldsImplementation() {
        // 1. Arrange
        var fieldNamesFromIntance = Set(Mirror(reflecting: master).children.compactMap { $0.label })
        let fieldNamesFromNamesStruct = Set(Mirror(reflecting: AccountGroupFields()).children.compactMap { $0.label })
        let fieldNamesFromNamesStructValues = Set(Mirror(reflecting: AccountGroupFields()).children.compactMap { ($0.value as? String) ?? "" })
        let fieldNamesFromEnum = Set(AccountGroupField.allCases.map { $0.rawValue })
        fieldNamesFromIntance.remove("update.storage")
        // 3. Assert
        XCTAssertTrue(fieldNamesFromIntance == fieldNamesFromNamesStruct)
        XCTAssertTrue(fieldNamesFromNamesStruct == fieldNamesFromEnum)
        XCTAssert(fieldNamesFromNamesStruct == fieldNamesFromNamesStructValues)
    }

    /// Test checks that object is correctly initialized with dictionary of [field: value]
    internal func testInitWithData() {
        // 1. Arrange
        let data = ["name": "name"]

        // 2. Action
        let sample = AccountGroup(data)

        // 3. Assert
        master.name = "name"
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates name, when ["name": "some name"] is submitted
    internal func testUpdateWithNameFieldValue() {
        // 1. Arrange
        let field = "name"
        let value = "name"

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        master.name = "name"
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates amount
    internal func testUpdateWithAmountFieldValue() {
        // 1. Arrange
        let field = "amount"
        let value = Int.random(in: 1 ..< 100)
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        master.amount = value
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates groups,
    /// when ["groups": ["group id": "group name"]]] is submitted
    internal func testUpdateWithGroupsFieldValue() {
        // 1. Arrange
        let field = "accounts"
        let value = ["account id": "account name"]
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        master.accounts = value
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates min value and date, when ["min" : ["amount": 10, "date": {timestamp}]] is submitted
    internal func testUpdateWithMinAmountFieldValue() {
        // 1. Arrange
        let field = "minAmount"
        let value: [String: Any] = ["amount": 10]
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        master.minAmount = 10
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates min value and date, when ["min" : ["amount": 10, "date": {timestamp}]] is submitted
    internal func testUpdateWithMinDateFieldValue() {
        // 1. Arrange
        let field = "minDate"
        let minDate = Date()
        let value: [String: Any] = ["date": Timestamp(date: minDate)]
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        master.minDate = minDate
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly doesn't change object, when some wrong field is submitted
    internal func testUpdateWithWrongFieldName() {
        // 1. Arrange
        let field = "wrong field name"
        let value = 0
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly doesn't change object, when wrong min field is submitted
    internal func testUpdateWithWrongMinFieldName() {
        // 1. Arrange
        let field = "min"
        let value: [String: Any] = [:]
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        XCTAssertEqual(master, sample)
    }
}
