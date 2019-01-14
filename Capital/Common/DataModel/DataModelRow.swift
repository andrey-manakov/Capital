internal protocol DataModelRowProtocol {
    var texts: [DataModelRowText: String] { get set }
//    var left: String? { get set }
//    var up: String? { get set }
//    var down: String? { get set }
//    var right: String? { get set }
    var height: CGFloat? { get set }
    var style: CellStyle? { get set }
    var selectAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? { get set }
    var accessory: Int? { get set }
    var filter: Any? { get set }
}

internal struct DataModelRow: DataModelRowProtocol {
    internal var texts = [DataModelRowText: String]()
//    internal var id: String?
//    internal var name: String?
//    internal var desc: String?
//    internal var left: String?
//    internal var up: String?
//    internal var down: String?
//    internal var right: String?
    internal var height: CGFloat?
    internal var style: CellStyle?
    internal var selectAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)?
    internal var accessory: Int?
    internal var filter: Any?

//    internal var description: String {
//        return "name \(self.texts[.name] ?? "nil") desc \(self.texts[.desc] ?? "nil")"
//    }

    internal init(
//        id: String? = nil,
//        name: String? = nil,
//        desc: String? = nil,
//        height: CGFloat? = nil,
//        left: String? = nil,
//        up: String? = nil,
//        down: String? = nil,
//        right: String? = nil,
        style: CellStyle? = nil,
        action: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? = nil,
        accessory: Int? = nil,
        filter: Any? = nil
        ) {
//        self.id = id
//        self.name = name
//        self.desc = desc
//        self.height = height
//        self.left = left
//        self.up = up
//        self.down = down
//        self.right = right
        self.style = style
        self.selectAction = action
        self.accessory = accessory
        self.filter = filter
    }

    internal init(
        texts: [DataModelRowText: String] = [DataModelRowText: String](),
        height: CGFloat? = nil,
        style: CellStyle? = nil,
        accessory: Int? = nil,
        filter: Any? = nil,
        action: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? = nil
         ) {
        self.texts = texts
        self.height = height
        self.accessory = accessory
        self.style = style
        self.filter = filter
        self.selectAction = action
    }
}

internal enum DataModelRowText: String, CaseIterable {
    case id
    case name
    case desc
    case left
    case up
    case down
    case right
}
