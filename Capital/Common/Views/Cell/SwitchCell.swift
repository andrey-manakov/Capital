/// Protocol to access `SimpleSwitch`
internal protocol SwitchProtocol: AnyObject {
}
/// Simple UISwitch
internal class SimpleSwitch: UISwitch, SwitchProtocol {
}
/// Protocol to access `SwitchCell`
internal protocol SwitchCellProtocol {
	/// Text label inside the cell to the left
    var textLabel: UILabel? { get }
}
/// Cell with UISwitch to the right
internal final class SwitchCell: UITableViewCell, SwitchCellProtocol {
	// MARK: - Properties
	/// UISwitch control for the cell
    internal var switchControl: SwitchProtocol = SimpleSwitch()
    // MARK: - Initializers
    /// Initializes with style and reuseIdentifier. This overrides designated initializer and configure cell
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(view: switchControl as? UIView, withConstraints: ["H:[v(50)]-20-|", "V:|[v]|"])
    }
    /// Returns nil and implemented since it is required
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
