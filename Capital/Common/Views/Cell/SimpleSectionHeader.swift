import UIKit

protocol SimpleSectionHeaderProtocol {
    var title: UILabel {get}
    var desc: UILabel {get}
}

class SimpleSectionHeader: UITableViewHeaderFooterView, SimpleSectionHeaderProtocol {
    var title = UILabel()
    var desc = UILabel()

    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.add(subView: title, withConstraints: ["H:|-15-[v]-65-|", "V:|-7-[v(30)]"])
        contentView.add(subView: desc, withConstraints: ["H:[v(50)]-15-|", "V:|-7-[v(30)]"])
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}
