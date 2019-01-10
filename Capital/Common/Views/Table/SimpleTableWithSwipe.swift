import UIKit

protocol SimpleTableWithSwipeProtocol: SimpleTableProtocol {
    var swipeLeftLabel: String? { get set }
    var swipeRightLabel: String? { get set }
    var swipeLeftAction: ((_ row: DataModelRowProtocol?) -> Void)? { get set }
    var swipeRightAction: ((_ row: DataModelRowProtocol?) -> Void)? { get set }
}

class SimpleTableWithSwipe: SimpleTable, SimpleTableWithSwipeProtocol {

    var swipeLeftLabel: String?
    var swipeRightLabel: String?
    var swipeLeftAction: ((_ row: DataModelRowProtocol?) -> Void)?
    var swipeRightAction: ((_ row: DataModelRowProtocol?) -> Void)?

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let handler = {[unowned self] (_:UIContextualAction, _:UIView, success: (Bool) -> Void) in
            self.swipeRightAction?(self.data[indexPath])
            success(true)
        }
        let rightSwipe = UIContextualAction(style: .normal, title: swipeRightLabel ?? "", handler: handler)
        rightSwipe.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [rightSwipe])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let handler = {(_:UIContextualAction, _:UIView, success: (Bool) -> Void) in
            self.swipeLeftAction?(self.data[indexPath])
            success(true)
        }
        let leftSwipe = UIContextualAction(style: .normal, title: swipeLeftLabel ?? "", handler: handler)
        leftSwipe.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [leftSwipe])
    }
}
