
import UIKit

protocol SwitchProtocol: class {
    
}

class SimpleSwitch: UISwitch, SwitchProtocol {
    
}


protocol SwitchCellProtocol {
    var textLabel: UILabel? {get}
}

class SwitchCell: UITableViewCell, SwitchCellProtocol {
    var switchControl: SwitchProtocol = SimpleSwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(subView: switchControl as? UIView, withConstraints: ["H:[v(50)]-20-|", "V:|[v]|"])
    }
    
    required init?(coder aDecoder: NSCoder) {return nil}
    
}
