@testable import Capital
import XCTest

internal class AccountTypeTests: XCTestCase {
    internal func testActiveAsset() {
        for type in AccountType.allCases {
            let result = type.active
            return XCTAssertTrue(result)
        }
    }

    internal func testNameTests() {
        for type in AccountType.allCases {
            let name: String
            switch type {
            case .asset:
                name = "asset"
            case .expense:
                name = "expense"
            case .liability:
                name = "liability"
            case .capital:
                name = "capital"
            case .revenue:
                name = "revenue"
            }
            return XCTAssert(type.name == name)
        }
    }
}
