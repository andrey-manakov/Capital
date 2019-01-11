internal protocol LeftRightCellProtocol: AnyObject {
    var textLabel: UILabel? { get }
    var detailTextLabel: UILabel? { get }
    var accessoryType: UITableViewCell.AccessoryType { get set }
}

internal final class LeftRightCell: UITableViewCell, LeftRightCellProtocol {
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.textColor = .black
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
