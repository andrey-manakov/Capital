internal final class AccountGroupDetailVC: ViewController {

    override internal func viewDidLoad() {
        super.viewDidLoad()
        let service = Service()

        let table: SimpleTableProtocol = SimpleTable()
        if let data = data as? (id: String, name: String) {
            service.getData(withId: data.id) { dataModel in
                table.localData = dataModel
            }
            table.didSelect = {[unowned self] row, _ in
                let viewController = AccountTransactionsVC((row.id, row.name))
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            title = data.name
            navigationItem.rightBarButtonItem = BarButtonItem(title: "Edit") {[unowned self] in
                let viewController = AccountGroupEditVC((data.id, data.name))
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        view.add(subView: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
    }

}

extension AccountGroupDetailVC {
    private class Service: ClassService {
        private var accounts = [String: Account]()

        func getData(withId id: String?, completion: @escaping ((DataModelProtocol) -> Void)) {
            guard let id = id else {
                return
            }
            data.setListnersToAccountsInGroup(withId: id, for: self.id, completion: { data in
                for (id, account, changeType) in data {
                    switch changeType {
                    case .added, .modified:
                        self.accounts[id] = account
                    case .removed:
                        self.accounts.removeValue(forKey: id)
                    }
                }
                let dataModel = DataModel(self.accounts.map {
                    (id: $0.key, name: $0.value.name, desc: "\($0.value.amount ?? 0)")
                })
                completion(dataModel)
            })
        }

        func deleteAccountGroup(id: String) {
            data.deleteAccountGroup(withId: id, completion: nil)
        }

    }
}
