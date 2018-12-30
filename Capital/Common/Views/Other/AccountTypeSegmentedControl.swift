//
//import UIKit
//
//protocol AccountTypesSegmentedControlProtocol {
//    var actionOnValueChange: ((AccountType)->())? {get set}
//    var selectedAccountType: AccountType? {get set}
//    func removeFromSuperview()
//}
//
//class AccountTypesSegmentedControl: UISegmentedControl, AccountTypesSegmentedControlProtocol {
//    var selectedAccountType: AccountType? {get {return AccountType(rawValue: self.selectedSegmentIndex)} set(newValue) {
//            self.selectedSegmentIndex = newValue?.rawValue ?? 0
//        }
//    }
//    var actionOnValueChange: ((AccountType) -> ())?
//    
//    init(_ actionOnValueChange: ((AccountType)->())? = nil) {
//        super.init(frame: CGRect.zero)
//        for i in 0..<AccountType.all.count {//TODO: change to all cases
//            self.insertSegment(withTitle: AccountType.all[i], at: i, animated: false)
//            self.selectedSegmentIndex = 0
//        }
//        addTarget(self, action: #selector(self.didChangeValue(sender:)), for: UIControl.Event.valueChanged)
//        self.actionOnValueChange = actionOnValueChange
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    @objc func didChangeValue(sender: UISegmentedControl) {
//        guard let accountType = AccountType(rawValue: selectedSegmentIndex) else {return}
//        actionOnValueChange?(accountType)
//    }
//    
//}
//
//
