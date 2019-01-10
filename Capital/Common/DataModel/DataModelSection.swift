protocol DataModelSectionProtocol: BasicDataPropertiesProtocol {
    var rows: [DataModelRowProtocol] { get set }
    func filter(_: ((DataModelRowProtocol) -> (Bool))) -> DataModelSectionProtocol
}

struct DataModelSection: DataModelSectionProtocol {
    var id: String?
    var name: String?
    var desc: String?
    var rows: [DataModelRowProtocol] = [DataModelRow]()

    var description: String {
        var description = "Section \(name ?? "") \(desc ?? "") with \(rows.count) rows\n"
        for row in rows {
            description += "\(row)\n"
        }
        return description
    }

    subscript(rowIndex: Int) -> (name: String?, desc: String?) {
        let row = rows[rowIndex]
        return (row.name, row.desc)
    }

    init() {}
    init(_ rows: [DataModelRowProtocol]) {
        self.rows = rows
    }
    init(_ labels: [String]) {
        for label in labels {
            rows.append(DataModelRow(name: label))
        }
    }
//    init(_ labels: [(name: String, desc: String)]) {
//        for label in labels {rows.append(DataModelRow(name: label.name, desc: label.desc))}
//    }
    init(_ labels: [(id: String?, name: String?, desc: String?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name, desc: label.desc))
        }
    }

    init(_ labels: [(id: String?, name: String?, desc: String?, filter: Any?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name, desc: label.desc, filter: label.filter))
        }
    }

    init(_ labels: [(id: String?, name: String?, desc: String?, accessory: Int?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name,
                                     desc: label.desc, accessory: label.accessory))
        }
    }

    init(_ labels: [(id: String?, name: String?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name))
        }
    }

    init(_ labels: [(id: String?, name: String?, desc: String?, height: CGFloat?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, name: label.name, desc: label.desc, height: label.height))
        }
    }

    init(_ labels: [(id: String?, left: String?, up: String?, down: String?, right: String?)]) {
        for label in labels {
            rows.append(DataModelRow(id: label.id, left: label.left, up: label.up,
                                     down: label.down, right: label.right))
        }
    }

    func filter(_ filter: ((DataModelRowProtocol) -> (Bool))) -> DataModelSectionProtocol {
        return DataModelSection(self.rows.filter(filter))
    }

}
