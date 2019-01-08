import XCTest
@testable import Capital

class DataModelRowTests: XCTestCase {

    func testInit() {

        var selectActionCalled = false

        let id = "id"
        let name = "name"
        let desc = "desc"
        let left = "left"
        //swiftlint:disable identifier_name
        let up = "up"
        let down = "down"
        let right = "right"
        let height = CGFloat(10.2)
        let style = CellStyle.leftRightCell
        let action: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? = {_, _ in
            selectActionCalled = true
        }
        let accessory = 1
        let filter = "Any?"

        let sample = DataModelRow(
            id: id, name: name, desc: desc, height: height, left: left, up: up, down: down,
            right: right, style: style, action: action, accessory: accessory, filter: filter)
        var master = DataModelRow()
        master.id = id
        master.name = name
        master.desc = desc
        master.height = height
        master.left = left
        master.up = up
        master.down = down
        master.right = right
        master.style = style
        master.selectAction = action
        master.accessory = accessory
        master.filter = filter
        XCTAssertEqual(master, sample)
        sample.selectAction!(DataModelRow(), IndexPath())
        XCTAssertTrue(selectActionCalled)
        XCTAssertTrue((sample.filter as? String) == "Any?")
    }
}
