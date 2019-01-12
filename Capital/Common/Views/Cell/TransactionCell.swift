internal protocol TransactionCellProtocol: AnyObject {
    var date: SimpleLabelProtocol { get set }
    var from: SimpleLabelProtocol { get set }
    var to: SimpleLabelProtocol { get set }
    var amount: SimpleLabelProtocol { get set }
}

internal final class TransactionCell: UITableViewCell, TransactionCellProtocol {
    internal var date: SimpleLabelProtocol = SimpleLabel(alignment: .center, lines: 2)
    internal var from: SimpleLabelProtocol = SimpleLabel()
    internal var to: SimpleLabelProtocol = SimpleLabel()
    internal var amount: SimpleLabelProtocol = NumberLabel()

    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(
            subViews: [
                "date": date as? UIView, "from": from as? UIView,
                "to": to as? UIView, "amount": amount as? UIView
            ],
            withConstraints: [
                "H:|-15-[date(70)]-10-[from]-5-[amount(50)]-5-|",
                "H:|-95-[to(==from)]", "V:|[date]|", "V:|[from(22)]",
                "V:[to(22)]|", "V:|[amount]|"
            ])
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
