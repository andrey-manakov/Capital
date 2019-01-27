import UIKit
/// Protocol to access `SimpleSectionHeader`
internal protocol SimpleSectionHeaderProtocol {
    /// Title text label inside the cell to the left
    var title: UILabel { get }
    /// Description text label inside the cell to the right
    var desc: UILabel { get }
}
/// Section header cell for sections in UITableView
internal class SimpleSectionHeader: UITableViewHeaderFooterView, SimpleSectionHeaderProtocol {
    // MARK: - Properties
    /// Title text label inside the cell to the left
    internal var title = UILabel()
    /// Description text label inside the cell to the right
    internal var desc = UILabel()
    // MARK: - INitializers
    override internal init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.add(view: title, withConstraints: ["H:|-15-[v]-65-|", "V:|-7-[v(30)]"])
        contentView.add(view: desc, withConstraints: ["H:[v(50)]-15-|", "V:|-7-[v(30)]"])
    }
    /// Returns nil and implented since it is required
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
