internal protocol SwitchProtocol: AnyObject {
}

internal class SimpleSwitch: UISwitch, SwitchProtocol {
}

internal protocol SwitchCellProtocol {
    var textLabel: UILabel? { get }
}

internal final class SwitchCell: UITableViewCell, SwitchCellProtocol {
    internal var switchControl: SwitchProtocol = SimpleSwitch()

    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(view: switchControl as? UIView, withConstraints: ["H:[v(50)]-20-|", "V:|[v]|"])
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
