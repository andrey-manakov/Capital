@testable import Capital
import XCTest

internal class AccountTests: XCTestCase {
    internal var master = Account()
    internal var sample = Account()

    /// Test that properties list of `Account` is correctly treated
    internal func testFieldsImplementation() {
        var fieldNamesFromInstance = Set(Mirror(reflecting: master).children.compactMap { $0.label })
        let fieldNamesFromNamesStruct = Set(Mirror(reflecting: AccountFields()).children.compactMap { $0.label })
        let fieldNamesFromNamesStructValues = Set(Mirror(reflecting: AccountFields()).children.compactMap { ($0.value as? String) ?? "" })
        let fieldNamesFromEnum = Set(AccountField.allCases.map { $0.rawValue })
        fieldNamesFromInstance.remove("update.storage")
        XCTAssertTrue(fieldNamesFromInstance == fieldNamesFromNamesStruct)
        XCTAssertTrue(fieldNamesFromNamesStruct == fieldNamesFromEnum)
        XCTAssert(fieldNamesFromNamesStruct == fieldNamesFromNamesStructValues)
    }

    /// Test checks that object is correctly initialized with dictionary of [field: value]
    internal func testInitWithData() {
        // 1. Arrange
        let data = ["name": "name"]
        // 2. Action
        let sample = Account(data)
        // 3. Assert
        master.name = "name"
        XCTAssertEqual(sample, master)
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
        XCTAssertEqual(sample, master)
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
        XCTAssertEqual(sample, master)
    }

    /// Test checks that code correctly updates typeId
    internal func testUpdateWithTypeFieldValue() {
        // 1. Arrange
        let field = "typeId"
        let value = Int.random(in: 1 ... 4)
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        master.typeId = value
        XCTAssertEqual(sample, master)
    }

    /// Test checks that code correctly updates groups
    internal func testUpdateWithGroupsFieldValue() {
        // 1. Arrange
        let field = "groups"
        let value = ["group id": "group name"]
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        master.groups = value
        XCTAssertEqual(sample, master)
    }

    /// Test checks that code correctly updates min amount
    internal func testUpdateWithMinAmountFieldValue() {
        // 1. Arrange
        let field = "minAmount"
        let value = Int.random(in: 1 ..< 100)
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        master.minAmount = value
        XCTAssertEqual(sample, master)
    }

    /// Test checks that code correctly updates min date
    internal func testUpdateWithMinDateFieldValue() {
        // 1. Arrange
        let field = "minDate"
        let minDate = Date()
        let value = minDate
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        master.minDate = minDate
        XCTAssertEqual(sample, master)
    }

    /// Test checks that code correctly process wrong field name
    internal func testUpdateWithWrongFieldName() {
        // 1. Arrange
        let field = "wrong field name"
        let value = 0
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        XCTAssertEqual(sample, master)
    }

    /// Test checks that code correctly process wrong min field name
    internal func testUpdateWithWrongMinFieldName() {
        // 1. Arrange
        let field = "min"
        let value: [String: Any] = [:]
        // 2. Action
        sample.update(field: field, value: value)
        // 3. Assert
        XCTAssertEqual(sample, master)
    }
}
