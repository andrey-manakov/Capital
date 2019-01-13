import UIKit

internal protocol SimpleSectionHeaderProtocol {
    var title: UILabel { get }
    var desc: UILabel { get }
}

internal class SimpleSectionHeader: UITableViewHeaderFooterView, SimpleSectionHeaderProtocol {
    internal var title = UILabel()
    internal var desc = UILabel()

    override internal init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.add(view: title, withConstraints: ["H:|-15-[v]-65-|", "V:|-7-[v(30)]"])
        contentView.add(view: desc, withConstraints: ["H:[v(50)]-15-|", "V:|-7-[v(30)]"])
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
