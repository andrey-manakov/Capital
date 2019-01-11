internal protocol DateSelectionCellProtocol {
    var actionOnDateChange: ((_ date: Date) -> Void)? { get set }
    var date: Date? { get set }
}

internal final class DateSelectionCell: UITableViewCell, DateSelectionCellProtocol {
    internal var date: Date? = Date() { didSet { if let date = date { datePicker.date = date } } }
    internal var datePicker: DatePickerProtocol = DatePicker()
    internal var actionOnDateChange: ((_ date: Date) -> Void)? {
        didSet { datePicker.actionOnDateChange = self.actionOnDateChange }
    }

    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(subView: datePicker as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
