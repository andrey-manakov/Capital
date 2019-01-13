internal protocol BasicDataPropertiesProtocol: CustomStringConvertible, CustomDebugStringConvertible {
    var id: String? { get set }
    var name: String? { get set }
    var desc: String? { get set }
}

extension BasicDataPropertiesProtocol {
    internal var description: String {
        return "\(type(of: self)) \(id ?? "nil") \(name ?? "nil") \(desc ?? "nil")"
    }
    internal var debugDescription: String { return description }
}

internal protocol DataModelProtocol: CustomStringConvertible, CustomDebugStringConvertible {
    var sections: [DataModelSectionProtocol] { get set }

    subscript(index: IndexPath) -> DataModelRowProtocol { get set }
    func filter(_: (DataModelRowProtocol) -> (Bool)) -> DataModelProtocol
}

internal struct DataModel: DataModelProtocol {
    // MARK: - Properties
    /// Sections for the UITableView
    internal var sections: [DataModelSectionProtocol] = [DataModelSection]()

    internal var description: String {
        var desc = "-------- Data Model with \(sections.count) sections -------\n"
        for section in sections {
            desc += "\(section) \n"
        }
        return desc
    }

    internal var debugDescription: String { return self.description }

    internal subscript(sectionIndex: Int, rowIndex: Int) -> (name: String?, desc: String?) {
        let row = sections[sectionIndex].rows[rowIndex]
        return (row.name, row.desc)
    }

    internal subscript(index: IndexPath) -> DataModelRowProtocol {
        get {
            return sections[index.section].rows[index.row]
        }
        set {
            sections[index.section].rows[index.row] = newValue
        }
    }

    // MARK: - Initializers

    internal init() {}
    internal init(_ labels: [(id: String?, name: String?, desc: String?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }
// remove first
    internal init(_ labels: [(id: String?, name: String?, desc: String?, filter: Any?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }

    internal init(_ labels: [(id: String?, name: String?, desc: String?, accessory: Int?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }
    internal init(_ labels: [(id: String?, name: String?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }
    internal init(_ labels: [(id: String?, name: String?, desc: String?, height: CGFloat?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }

    internal init(_ labels: [(id: String?, left: String?, up: String?, down: String?, right: String?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }

    internal init(_ sections: [DataModelSectionProtocol]) {
        self.sections = sections
    }

    internal init(_ rows: [DataModelRowProtocol]) {
        self.sections.append(DataModelSection(rows))
    }

    // MARK: - Functions

    internal func filter(_ filter: (DataModelRowProtocol) -> (Bool)) -> DataModelProtocol {
        return DataModel(sections.map { $0.filter(filter) })
    }
}
