class AccountDetailVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let service = AccountDetailService() //should be private
        let accountNameTextField: TextFieldProtocol = SimpleTextField()
        let accountAmountTextField: TextFieldProtocol = NumberField()

        let id = data as? String
        if let id = id {
            let button: ButtonProtocol = Button(name: "Delete") {[unowned self] in
                service.didTapDelete(withId: id)
                self.navigationController?.popViewController(animated: true)
            }
            let constraints = ["H:|-20-[deleteButton]-20-|", "V:[deleteButton(44)]-60-|"]
            view.add(subViews: ["deleteButton": button as? UIView], withConstraints: constraints)
        }

        navigationItem.rightBarButtonItem = BarButtonItem(title: "Done") {[unowned self] in
                service.didTapDone(with: id, name: accountNameTextField.text ?? "",
                                   amount: accountAmountTextField.text ?? "")
                self.navigationController?.popViewController(animated: true)
        }

        view.add(subViews: ["accountName": accountNameTextField as? UIView,
                            "accountAmount": accountAmountTextField as? UIView], withConstraints: [
                                "H:|-20-[accountName]-20-|", "H:|-20-[accountAmount]-20-|",
                                "V:|-120-[accountName(31)]-20-[accountAmount(31)]"])
    }

}

extension AccountDetailVC {
    private class AccountDetailService: ClassService {//should be private

        func didTapDone(with id: String?, name: String, amount: String) {
            if let id = id {
                data.updateAccount(withId: id, name: name, amount: Int(amount), completion: nil)
            }

        }

        func didTapDelete(withId id: String) {
            data.deleteAccount(withId: id, completion: nil)
        }
    }
}
