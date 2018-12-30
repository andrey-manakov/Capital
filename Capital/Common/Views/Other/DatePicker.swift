
import UIKit

protocol DatePickerProtocol: class {
    var actionOnDateChange: ((_ date: Date)->())? {get set}
    var date: Date {get set}
}

class DatePicker: UIDatePicker, DatePickerProtocol {
    
    var actionOnDateChange: ((_ date: Date)->())?
    
    init(actionOnDateChange: ((_ date: Date)->())? = nil) {
        super.init(frame: .zero)
        datePickerMode = .date
        addTarget(self, action: #selector(dateChanged), for: UIControl.Event.valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {fatalError("")}
    
    @objc func dateChanged() {actionOnDateChange?(date)}
}
