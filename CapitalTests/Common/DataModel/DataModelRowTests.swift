@testable import Capital
import XCTest

internal class DataModelRowTests: XCTestCase {
    internal func testInit() {
        var selectActionCalled = false

        let id = "id"
        let name = "name"
        let desc = "desc"
        let left = "left"
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
            texts: [
                .id: id,
                .name: name,
                .desc: desc,
                .left: left,
                .up: up,
                .down: down,
                .right: right
            ],
            height: height,
            style: style,
            accessory: accessory,
            filter: filter,
            action: action)
        var master = DataModelRow()
        master.texts[.id] = id
        master.texts[.name] = name
        master.texts[.desc] = desc
        master.height = height
        master.texts[.left] = left
        master.texts[.up] = up
        master.texts[.down] = down
        master.texts[.right] = right
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
