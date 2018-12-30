
import UIKit

protocol SimpleTableWithSwipeProtocol: SimpleTableProtocol {
    var swipeLeftLabel: String? {get set}
    var swipeRightLabel: String? {get set}
    var swipeLeftAction: ((_ row: DataModelRowProtocol?) -> ())? {get set}
    var swipeRightAction: ((_ row: DataModelRowProtocol?) -> ())? {get set}
}

class SimpleTableWithSwipe: SimpleTable, SimpleTableWithSwipeProtocol {

    var swipeLeftLabel: String?
    var swipeRightLabel: String?
    var swipeLeftAction: ((_ row: DataModelRowProtocol?) -> ())?
    var swipeRightAction: ((_ row: DataModelRowProtocol?) -> ())?

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rightSwipe = UIContextualAction(style: .normal, title:  swipeRightLabel ?? ""){
            [unowned self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.swipeRightAction?(self.data[indexPath])
            success(true)
        }
        rightSwipe.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [rightSwipe])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leftSwipe = UIContextualAction(style: .normal, title:  swipeLeftLabel ?? "") {
            (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.swipeLeftAction?(self.data[indexPath])
            success(true)
        }
        leftSwipe.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [leftSwipe])
    }
}

