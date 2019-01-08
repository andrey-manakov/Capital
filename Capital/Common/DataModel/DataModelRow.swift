import UIKit

protocol DataModelRowProtocol: BasicDataPropertiesProtocol {
    var left: String? {get set}
    // swiftlint:disable identifier_name
    var up: String? {get set}
    var down: String? {get set}
    var right: String? {get set}
    var height: CGFloat? {get set}
    var style: CellStyle? {get set}
    var selectAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? {get set}
    var accessory: Int? {get set}
    var filter: Any? {get set}
}

struct DataModelRow: DataModelRowProtocol {
    var id: String?
    var name: String?
    var desc: String?
    var left: String?
    // swiftlint:disable identifier_name
    var up: String?
    var down: String?
    var right: String?
    var height: CGFloat?
    var style: CellStyle?
    var selectAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)?
    var accessory: Int?
    var filter: Any?

    var description: String {
        return "name \(name ?? "nil") desc \(desc ?? "nil")"
    }

    init(id: String? = nil, name: String? = nil, desc: String? = nil, height: CGFloat? = nil,
         left: String? = nil, up: String? = nil, down: String? = nil, right: String? = nil,
         style: CellStyle? = nil,
         action: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? = nil,
         accessory: Int? = nil, filter: Any? = nil) {
        self.id = id
        self.name = name
        self.desc = desc
        self.height = height
        self.left = left
        self.up = up
        self.down = down
        self.right = right
        self.style = style
        self.selectAction = action
        self.accessory = accessory
        self.filter = filter
    }

}

extension DataModelRow: Equatable {
    static func == (lhs: DataModelRow, rhs: DataModelRow) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.desc == rhs.desc &&
            lhs.height == rhs.height &&
            lhs.left == rhs.left &&
            lhs.up == rhs.up &&
            lhs.down == rhs.down &&
            lhs.right == rhs.right &&
            lhs.style == rhs.style &&
            lhs.accessory == rhs.accessory
    }

}
