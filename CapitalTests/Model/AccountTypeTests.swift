import XCTest
@testable import Capital

class AccountTypeTests: XCTestCase {
    func testActiveAsset() {
        for type in AccountType.allCases {
            switch type {
            case .asset, .expense: XCTAssert(type.active == true)
            case .liability, .capital, .revenue: XCTAssert(type.active == false)
            }
        }
    }

    func testNameTests() {
        for type in AccountType.allCases {
            switch type {
            case .asset: XCTAssert(type.name == "asset")
            case .expense: XCTAssert(type.name == "expense")
            case .liability: XCTAssert(type.name == "liability")
            case .capital: XCTAssert(type.name == "capital")
            case .revenue: XCTAssert(type.name == "revenue")
            }
        }
    }

}
