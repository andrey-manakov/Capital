/// View Controller showing `Account` details and allowing to edit
internal final class AccountDetailVC: ViewController {
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        let service = Service() // should be private
        let accountNameTextField: TextFieldProtocol = SimpleTextField()
        let accountAmountTextField: TextFieldProtocol = NumberField()
        // Get data provided for view controller configuration
        let id = data as? String
        if let id = id {
            let button: ButtonProtocol = Button(name: "Delete") {[unowned self] in
                service.didTapDelete(withId: id)
                self.navigationController?.popViewController(animated: true)
            }
            let constraints = ["H:|-20-[deleteButton]-20-|", "V:[deleteButton(44)]-60-|"]
            view.add(views: ["deleteButton": button as? UIView], withConstraints: constraints)
        }

        navigationItem.rightBarButtonItem = BarButtonItem(title: "Done") {[unowned self] in
                service.didTapDone(with: id, name: accountNameTextField.text ?? "",
                                   amount: accountAmountTextField.text ?? "")
                self.navigationController?.popViewController(animated: true)
        }

        view.add(views:
            [
                "accountName": accountNameTextField as? UIView,
                "accountAmount": accountAmountTextField as? UIView
            ],
                 withConstraints:
            [
                "H:|-20-[accountName]-20-|", "H:|-20-[accountAmount]-20-|",
                "V:|-120-[accountName(31)]-20-[accountAmount(31)]"
            ])
    }
}
/// Extension to provide view controller with service class
extension AccountDetailVC {
    /// Service class for `AccountDetailVC`
    private class Service: ClassService {
        /// Triggered when done button is tapped, calls Data Singleton to update `Account` with new values
        ///
        /// - Parameters:
        ///   - id: field to identify `Account` to update
        ///   - name: text to update `Account.name`
        ///   - amount: text to update `Account.amount`
        func didTapDone(with id: String?, name: String, amount: String) {
            if let id = id {
                data.updateAccount(withId: id, name: name, amount: Int(amount), completion: nil)
            }
        }
        /// Triggered when delete button is tapped, calls `Data.shared` Singleton to delete `Account`
        ///
        /// - Parameter id: field to identify `Account` to update
        func didTapDelete(withId id: String) {
            data.deleteAccount(withId: id, completion: nil)
        }
    }
}
