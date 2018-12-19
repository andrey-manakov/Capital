import XCTest
@testable import Capital

class NumberLabelTests: XCTestCase {
    func testInitWithCoder() {
        // 1. Arrange
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        
        // 2. Action
        let view =  NumberLabel(coder: archiver)
        
        // 3. Assert
        XCTAssertNil(view)
    }
    
    func testInitWithText() {
        //given
        let text = "1"
        //when
        let sample = NumberLabel(text)
        //then
        XCTAssertTrue(sample.text == text && sample.textAlignment == .right)
    }
}
