internal protocol SegmentedControlProtocol: class {
    var selectedSegmentIndex: Int { get set }
}

internal class SegmentedControl: UISegmentedControl, SegmentedControlProtocol {
    internal var actionOnValueChange: ((Int) -> Void)?

    internal init(_ titles: [String], _ actionOnValueChange: ((Int) -> Void)? = nil) {
        super.init(frame: CGRect.zero)
        for index in 0..<AccountType.all.count {
            self.insertSegment(withTitle: AccountType.all[index], at: index, animated: false)
            self.selectedSegmentIndex = 0
        }
        addTarget(self, action: #selector(self.didChangeValue(sender:)), for: UIControl.Event.valueChanged)
        self.actionOnValueChange = actionOnValueChange
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc internal func didChangeValue(sender: UISegmentedControl) {
        actionOnValueChange?(selectedSegmentIndex)
    }

}
