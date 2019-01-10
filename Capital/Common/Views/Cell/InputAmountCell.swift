import UIKit

protocol InputAmountCellProtocol {
    var amountTextField: TextFieldProtocol { get set }
    var textLabel: UILabel? { get }
}

class InputAmountCell: UITableViewCell, InputAmountCellProtocol {
    var amountTextField: TextFieldProtocol = RightNumberField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(subView: amountTextField as? UIView, withConstraints: ["H:[v(100)]-20-|", "V:|[v]|"])
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
