class AccountGroupDetailVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let service = Service()

        let table: SimpleTableProtocol = SimpleTable()
        if let data = data as? (id: String, name: String) {
            service.getData(withId: data.id) {dataModel in table.localData = dataModel}
            table.didSelect = {[unowned self] row, ix in
                self.navigationController?.pushViewController(AccountTransactionsVC((row.id, row.name)), animated: true)
            }
            title = data.name
            navigationItem.rightBarButtonItem = BarButtonItem(title: "Edit") {[unowned self] in
                self.navigationController?.pushViewController(AccountGroupEditVC((data.id, data.name)), animated: true)
            }
        }
        view.add(subView: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
    }

}

extension AccountGroupDetailVC {
    private class Service: ClassService {
        private var accounts = [String: Account]()
        func getData(withId id: String?, completion: @escaping ((DataModelProtocol) -> Void)) {
            guard let id = id else {return}
            data.setListnersToAccountsInGroup(withId: id, for: self.id, completion: { data in
                for (id, account, changeType) in data {
                    switch changeType {
                    case .added, .modified: self.accounts[id] = account
                    case .removed: self.accounts.removeValue(forKey: id)
                    }
                }
                completion(DataModel(self.accounts.map {(id: $0.key, name: $0.value.name, desc: "\($0.value.amount ?? 0)")}))
            })
        }

        func deleteAccountGroup(id: String) {
            data.deleteAccountGroup(withId: id, completion: nil)
        }
    }
}
