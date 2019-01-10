protocol DataModelSectionProtocol: BasicDataPropertiesProtocol {
    var rows: [DataModelRowProtocol] { get set }

    func filter(_: ((DataModelRowProtocol) -> (Bool))) -> DataModelSectionProtocol
}

internal struct DataModelSection: DataModelSectionProtocol {
    internal var id: String?
    internal var name: String?
    internal var desc: String?
    internal var rows: [DataModelRowProtocol] = [DataModelRow]()

    internal var description: String {
        var description: String = "Section \(name ?? "") \(desc ?? "") with \(rows.count) rows\n"
        for row in rows {
            description += "\(row)\n"
        }
        return description
    }

    subscript(rowIndex: Int) -> (name: String?, desc: String?) {
        let row = rows[rowIndex]
        return (row.name, row.desc)
    }

    internal init() {}
    internal init(_ rows: [DataModelRowProtocol]) {
        self.rows = rows
    }
    internal init(_ labels: [String]) {
        for label in labels {
            rows.append(DataModelRow(name: label))
        }
    }
//    init(_ labels: [(name: String, desc: String)]) {
//        for label in labels {rows.append(DataModelRow(name: label.name, desc: label.desc))}
//    }
    internal init(_ labels: [(id: String?, name: String?, desc: String?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name, desc: label.desc))
        }
    }

    internal init(_ labels: [(id: String?, name: String?, desc: String?, filter: Any?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name, desc: label.desc, filter: label.filter))
        }
    }

    internal init(_ labels: [(id: String?, name: String?, desc: String?, accessory: Int?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name,
                                     desc: label.desc, accessory: label.accessory))
        }
    }

    internal init(_ labels: [(id: String?, name: String?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name))
        }
    }

    internal init(_ labels: [(id: String?, name: String?, desc: String?, height: CGFloat?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name, desc: label.desc, height: label.height))
        }
    }

    internal init(_ labels: [(id: String?, left: String?, up: String?, down: String?, right: String?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, left: label.left, up: label.up,
                                     down: label.down, right: label.right))
        }
    }

    internal func filter(_ filter: ((DataModelRowProtocol) -> (Bool))) -> DataModelSectionProtocol {
        return DataModelSection(self.rows.filter(filter))
    }
}
