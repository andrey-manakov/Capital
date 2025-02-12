internal protocol SimpleTableWithSelectionProtocol: SimpleTableProtocol {
    var selectedRow: DataModelRowProtocol? { get set }
}

internal class SimpleTableWithSelection: SimpleTable, SimpleTableWithSelectionProtocol {
    internal var selectedRow: DataModelRowProtocol?

    override internal init() {
        super.init()
        didSelect = {[unowned self] row, _ in
            self.selectedRow = row
            self.reloadData()
        }
    }

    override internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: LeftRightCell.self.description())
        cell?.textLabel?.text = data[indexPath].texts[.name]
        cell?.detailTextLabel?.text = data[indexPath].texts[.desc]
        cell?.selectionStyle = .none
        if data[indexPath].texts[.id] == selectedRow?.texts[.id] {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell ?? UITableViewCell()
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
