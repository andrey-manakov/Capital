class AccountListVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let service = Service()
        var selectedSegment = 0
        title = "Accounts"
        let table: SimpleTableProtocol = SimpleTable()
        let segmentedControl: SegmentedControlProtocol = SegmentedControl(AccountType.allCases.map {$0.name}) {[unowned table] i in
            table.filter = {$0.filter as? Int == i}
            selectedSegment = i
        }
        table.filter = {$0.filter as? Int == 0}
        service.getData { dataModel in table.localData = dataModel}
        navigationItem.rightBarButtonItem = BarButtonItem(title: "New") {[unowned self] in
            self.navigationController?.pushViewController(AccountNewVC(selectedSegment), animated: true)
        }

        table.didSelect = {[unowned self] row, ix in
            self.navigationController?.pushViewController(AccountTransactionsVC((row.id, row.name)), animated: true)}
        view.add(subViews: ["t": table as? UIView, "sc": segmentedControl as? UIView],
                 withConstraints: ["H:|[t]|", "H:|-20-[sc]-20-|", "V:|-80-[sc(31)]-5-[t]|"])
    }
}

extension AccountListVC {
    class Service: ClassService {

        private var accounts = [String: Account]() //{didSet{print(accountGroups)}}

        func getData(completion: @escaping ((DataModelProtocol)->Void)) {
            data.setListnerToAccounts(for: self.id) { data in
                for (id, account, changeType) in data {
                    switch changeType {
                    case .added, .modified: self.accounts[id] = account
                    case .removed: self.accounts.removeValue(forKey: id)
                    }
                }
                completion(DataModel(self.accounts.map {(id: $0.key, name: $0.value.name, desc: "\($0.value.amount ?? 0) (\($0.value.min?.amount ?? $0.value.amount ?? 0))", filter: $0.value.typeId ?? 4)}))
            }
        }

        func remove(_ row: DataModelRowProtocol?) {
            guard let id = row?.id else {return}
            data.delete(.group, withId: id)
        }
    }

}
