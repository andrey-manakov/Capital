
import UIKit

protocol DateSelectionCellProtocol {
    var actionOnDateChange: ((_ date: Date)->())? {get set}
    var date: Date? {get set}
}

class DateSelectionCell: UITableViewCell, DateSelectionCellProtocol {
    var date: Date? = Date() {didSet {if let date = date {datePicker.date = date}}}
    var datePicker: DatePickerProtocol = DatePicker()
    var actionOnDateChange: ((_ date: Date)->())? {didSet {datePicker.actionOnDateChange = self.actionOnDateChange}}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(subView: datePicker as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
    }
    
    required init?(coder aDecoder: NSCoder) {return nil}
}
