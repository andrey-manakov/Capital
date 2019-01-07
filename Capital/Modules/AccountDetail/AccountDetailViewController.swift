import UIKit

protocol AccountDetailViewControllerProtocol: ViewControllerProtocol {
//    var service: AccountDetailServiceProtocol {get set}
    var title: String? {get set}
    var accountNameTextField: TextFieldProtocol {get set}
    var accountAmountTextField: TextFieldProtocol {get set}
    var id: String? {get set}
}

class AccountDetailVC: ViewController, AccountDetailViewControllerProtocol {

    private let service: AccountDetailServiceProtocol = AccountDetailService()
    var accountNameTextField: TextFieldProtocol = SimpleTextField()
    var accountAmountTextField: TextFieldProtocol = NumberField()
    var id: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        id = data as? String
        let button: ButtonProtocol = Button(name: "Delete") {[unowned self] in
            self.service.didTapDelete(withId: self.id)
            self.navigationController?.popViewController(animated: true)
        }
        view.add(subViews: ["accountName": accountNameTextField as? UIView,
                            "accountAmount": accountAmountTextField as? UIView,
                            "deleteButton": button as? UIView],
                 withConstraints: ["H:|-20-[accountName]-20-|", "H:|-20-[accountAmount]-20-|", "H:|-20-[deleteButton]-20-|", "V:|-120-[accountName(31)]-20-[accountAmount(31)]", "V:[deleteButton(44)]-60-|"])

        service.viewDidLoad(self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(didTapDone))

    }

    @objc func didTapDone() {
        service.didTapDone(with: id, name: accountNameTextField.text ?? "", amount: accountAmountTextField.text ?? "")
        navigationController?.popViewController(animated: true)
    }

}
