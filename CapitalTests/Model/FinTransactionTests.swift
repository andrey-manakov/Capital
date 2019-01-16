@testable import Capital
import XCTest

internal class FinTransactionTests: XCTestCase {
    /// Test that properties list of `FinTransaction` is correctly treated
    internal func testFieldsImplementation() {
        let sample = FinTransaction()
        var fieldNamesFromIntance = Set(Mirror(reflecting: sample).children.compactMap { $0.label })
        var fieldNamesFromNamesStruct = Set(Mirror(reflecting: FinTransactionFields()).children.compactMap { ($0.value as? String) ?? "" })
        var fieldNamesFromEnum = Set(FinTransactionField.allCases.map { $0.rawValue })
        let fieldNamesFromUpdateDict = Set(sample.update.keys.map { $0.rawValue })
        fieldNamesFromIntance.remove("update.storage")
        XCTAssertTrue(fieldNamesFromNamesStruct == fieldNamesFromEnum)
        fieldNamesFromNamesStruct.remove("id")
        fieldNamesFromNamesStruct.remove("name")
        fieldNamesFromEnum.remove("id")
        fieldNamesFromEnum.remove("name")
        XCTAssertTrue(fieldNamesFromIntance == fieldNamesFromNamesStruct)
        XCTAssertTrue(fieldNamesFromEnum == fieldNamesFromUpdateDict)
    }

    /// Test checks that object is correctly initialized with dictionary of [field: value]
    internal func testInitWithData() {
        // 1. Arrange
        let data = ["amount": 10]

        // 2. Action
        let sample = FinTransaction(data)

        // 3. Assert
        let master = FinTransaction()
        master.amount = 10
        XCTAssertEqual(master, sample)
    }

    /// Test checks that code correctly updates amount, when ["amount": 10] is submitted
    internal func testUpdateWithAmountFieldValue() {
        // 1. Arrange
        let field = "amount"
        let value = 10
        let sample = FinTransaction()

        // 2. Action
        sample.update(field: field, value: value)

        // 3. Assert
        let master = FinTransaction()
        master.amount = 10
        XCTAssertEqual(master, sample)
    }
    // Check other fields

//    func testDescription() {
//        let currentDate = Date()
//        let transaction = FinTransaction(
//            from: ("id1", "account1"), to: ("id2", "account2"), amount: 10, date: currentDate)
//
//        XCTAssert(transaction.description ==
//            "from: account1 to: account2 amount: 10 date: \(currentDate.string)")
//        XCTAssert(transaction.debugDescription ==
//            "from: account1 to: account2 amount: 10 date: \(currentDate.string)")
//    }

    internal func testApprovalModeNames() {
        XCTAssert(FinTransaction.ApprovalMode.autoApprove.name == "Auto Approve" &&
            FinTransaction.ApprovalMode.autoCancel.name == "Auto Cancel" &&
            FinTransaction.ApprovalMode.autoPostpone.name == "Auto Postpone" &&
            FinTransaction.ApprovalMode.manual.name == "Manual")
    }

    internal func testDateText() {
        let currentDate = Date()
        let transaction = FinTransaction()
        transaction.date = currentDate
        XCTAssert(transaction.dateText == DateFormatter("yyyy MMM-dd").string(from: currentDate))
    }
}
