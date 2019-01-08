import UIKit

protocol SegmentedControlProtocol: class {
    var selectedSegmentIndex: Int {get set}
}

class SegmentedControl: UISegmentedControl, SegmentedControlProtocol {
    var actionOnValueChange: ((Int) -> Void)?

    init(_ titles: [String], _ actionOnValueChange: ((Int) -> Void)? = nil) {
        super.init(frame: CGRect.zero)
        for index in 0..<AccountType.all.count {
            self.insertSegment(withTitle: AccountType.all[index], at: index, animated: false)
            self.selectedSegmentIndex = 0
        }
        addTarget(self, action: #selector(self.didChangeValue(sender:)), for: UIControl.Event.valueChanged)
        self.actionOnValueChange = actionOnValueChange
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didChangeValue(sender: UISegmentedControl) {
        actionOnValueChange?(selectedSegmentIndex)
    }

}
