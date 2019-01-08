protocol BasicDataPropertiesProtocol: CustomStringConvertible, CustomDebugStringConvertible {
    var id: String? {get set}
    var name: String? {get set}
    var desc: String? {get set}

}

extension BasicDataPropertiesProtocol {
    var description: String {return "\(type(of: self)) \(id ?? "nil") \(name ?? "nil") \(desc ?? "nil")"}
    var debugDescription: String {return description}
}

protocol DataModelProtocol: CustomStringConvertible, CustomDebugStringConvertible {
    var sections: [DataModelSectionProtocol] {get set}
    subscript(index: IndexPath) -> DataModelRowProtocol {get set}
    func filter(_: (DataModelRowProtocol) -> (Bool)) -> DataModelProtocol
}

struct DataModel: DataModelProtocol {

    var sections: [DataModelSectionProtocol] = [DataModelSection]()

    var description: String {
        var desc = "-------- Data Model with \(sections.count) sections -------\n"
        for section in sections {
            desc += "\(section) \n"
        }
        return desc
    }

    var debugDescription: String {return self.description}

    subscript(sectionIndex: Int, rowIndex: Int) -> (name: String?, desc: String?) {
        let row = sections[sectionIndex].rows[rowIndex]
        return (row.name, row.desc)
    }

    subscript(index: IndexPath) -> DataModelRowProtocol {
        get {
            return sections[index.section].rows[index.row]
        }
        set {
            sections[index.section].rows[index.row] = newValue
        }
    }

    init() {}
    init(_ labels: [(id: String?, name: String?, desc: String?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }

    init(_ labels: [(id: String?, name: String?, desc: String?, filter: Any?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }

    init(_ labels: [(id: String?, name: String?, desc: String?, accessory: Int?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }
    init(_ labels: [(id: String?, name: String?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }
    init(_ labels: [(id: String?, name: String?, desc: String?, height: CGFloat?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }
    init(_ labels: [(id: String?, left: String?, up: String?, down: String?, right: String?)]) {
        self.init()
        sections.append(DataModelSection(labels))
    }

    init(_ sections: [DataModelSectionProtocol]) {
        self.sections = sections
    }

    init(_ rows: [DataModelRowProtocol]) {
        self.sections.append(DataModelSection(rows))
    }

    func filter(_ filter: (DataModelRowProtocol) -> (Bool)) -> DataModelProtocol {
        return DataModel(sections.map {$0.filter(filter)})
    }

}
