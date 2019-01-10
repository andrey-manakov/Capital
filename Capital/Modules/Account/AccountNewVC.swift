internal class AccountNewVC: ViewController {

    override internal func viewDidLoad() {
        super.viewDidLoad()
        let service = Service()
        let accountNameTextField: TextFieldProtocol = SimpleTextField("new account name")
        let accountAmountTextField: TextFieldProtocol = NumberField("initial account amount")
        var selectedSegment = data as? Int ?? 0

        let segmentedControl: SegmentedControlProtocol
        segmentedControl = SegmentedControl(AccountType.allCases.map { $0.name }) { segmentIndex in
            selectedSegment = segmentIndex
        }
        segmentedControl.selectedSegmentIndex = selectedSegment
        title = "New account"
        navigationItem.rightBarButtonItem = BarButtonItem(title: "Done") {
            service.didTapDoneWith(name: accountNameTextField.text,
                                   amount: accountAmountTextField.text,
                                   type: selectedSegment)
            self.navigationController?.popViewController(animated: true)
        }

        view.add(subViews: ["sc": segmentedControl as? UIView,
                            "an": accountNameTextField as? UIView,
                            "aa": accountAmountTextField as? UIView],
                 withConstraints: ["H:|-20-[an]-20-|",
                                   "H:|-20-[aa]-20-|",
                                   "H:|-20-[sc]-20-|",
                                   "V:|-80-[sc(31)]-20-[an(31)]-20-[aa(31)]"])
    }

}

extension AccountNewVC {
    private class Service: ClassService {

        func didTapDoneWith(name: String?, amount: String?, type accountType: Int) {
            data.createAccount(name, ofType: AccountType(rawValue: accountType),
                               withAmount: Int(amount ?? ""), completion: nil)
        }

    }
}
