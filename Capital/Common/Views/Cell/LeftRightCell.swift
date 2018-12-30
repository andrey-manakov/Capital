import UIKit

protocol LeftRightCellProtocol: class {
    var textLabel: UILabel? {get}
    var detailTextLabel: UILabel? {get}
    var accessoryType: UITableViewCell.AccessoryType {get set}
}

class LeftRightCell: UITableViewCell, LeftRightCellProtocol {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.textColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


