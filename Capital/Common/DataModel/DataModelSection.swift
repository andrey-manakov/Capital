internal protocol DataModelSectionProtocol: BasicDataPropertiesProtocol {
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

    internal subscript(rowIndex: Int) -> (name: String?, desc: String?) {
        let row = rows[rowIndex]
        return (row.texts[.name], row.texts[.desc])
    }

    internal init() {}
    internal init(_ rows: [DataModelRowProtocol]) {
        self.rows = rows
    }
    internal init(_ labels: [String]) {
        for label in labels {
            rows.append(DataModelRow(texts: [.name: label]))
        }
    }

    internal func filter(_ filter: ((DataModelRowProtocol) -> (Bool))) -> DataModelSectionProtocol {
        return DataModelSection(self.rows.filter(filter))
    }
}
