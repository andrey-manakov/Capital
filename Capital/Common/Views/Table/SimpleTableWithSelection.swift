import UIKit

protocol SimpleTableWithSelectionProtocol: SimpleTableProtocol {
    var selectedRow: DataModelRowProtocol? {get set}
}

class SimpleTableWithSelection: SimpleTable, SimpleTableWithSelectionProtocol {
    var selectedRow: DataModelRowProtocol?

    override init() {
        super.init()
        didSelect = {[unowned self] row, ix in
            self.selectedRow = row
            self.reloadData() //TODO: consider not updating ALL the rows
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: LeftRightCell.self.description())
        cell?.textLabel?.text = data[indexPath].name
        cell?.detailTextLabel?.text = data[indexPath].desc
        cell?.selectionStyle = .none
        if data[indexPath].id == selectedRow?.id {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }

    required init?(coder aDecoder: NSCoder) {return nil}
}
