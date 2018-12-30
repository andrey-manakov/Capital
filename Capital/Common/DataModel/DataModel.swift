
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
    subscript(i: IndexPath) -> DataModelRowProtocol {get set}
    func filter(_: (DataModelRowProtocol)->(Bool)) -> DataModelProtocol
}

struct DataModel: DataModelProtocol {
    

    var sections: [DataModelSectionProtocol] = [DataModelSection]()
    
    var description: String {
        var desc = "-------- Data Model with \(sections.count) sections -------\n"
        for section in sections {desc += "\(section) \n"}
        return desc
    }
    
    var debugDescription: String {return self.description}
    
    subscript(s: Int, r: Int) -> (name: String?, desc: String?) {
        let row = sections[s].rows[r]
        return (row.name, row.desc)
    }
    
    subscript(i: IndexPath) -> DataModelRowProtocol {
        get {
            return sections[i.section].rows[i.row]
        }
        set {
            sections[i.section].rows[i.row] = newValue
        }
    }

    
    init(){}
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
    init(_ labels: [(id: String?, name: String?)]) { //TODO: consider change to dict
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
    
    init(_ rows: [DataModelRowProtocol]) {self.sections.append(DataModelSection(rows))}
    
    func filter(_ filter: (DataModelRowProtocol) -> (Bool)) -> DataModelProtocol {
        return DataModel(sections.map{$0.filter(filter)})
    }
    
}



