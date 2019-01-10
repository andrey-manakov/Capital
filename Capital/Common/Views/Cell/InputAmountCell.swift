internal protocol InputAmountCellProtocol {
    var amountTextField: TextFieldProtocol { get set }
    var textLabel: UILabel? { get }
}

internal class InputAmountCell: UITableViewCell, InputAmountCellProtocol {
    internal var amountTextField: TextFieldProtocol = RightNumberField()

    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(subView: amountTextField as? UIView, withConstraints: ["H:[v(100)]-20-|", "V:|[v]|"])
    }

    required internal init?(coder aDecoder: NSCoder) {
        return nil
    }
}
