class AccountGroupEditVC: ViewController {
    private let service = Service()
    private let nameTextField: TextFieldProtocol = SimpleTextField("Account Group Name")

    override func viewDidLoad() {
        super.viewDidLoad()

        let table: SimpleTableProtocol = SimpleTable()
        let segmentedControl: SegmentedControlProtocol
        segmentedControl = SegmentedControl(
        AccountType.allCases.map { $0.name }) {[unowned table] selelctedIndex in
            table.filter = { $0.filter as? Int == selelctedIndex }
        }
        table.filter = { $0.filter as? Int == 0 }
        if let data = data as? (id: String, name: String) {
            service.accountGroup = data.id
            nameTextField.text = data.name
        }
        service.getData { dataModel in table.localData = dataModel }
        view.add(
            subViews: ["nm": nameTextField as? UIView, "sc": segmentedControl as? UIView,
                       "tbl": table as? UIView],
            withConstraints: ["H:|-15-[nm]-15-|", "H:|-20-[sc]-20-|", "H:|[tbl]|",
                              "V:|-80-[nm(31)]-20-[sc]-10-[tbl]|"])
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self, action: #selector(didTapDone))
        table.didSelect = {[unowned self] row, _ in
            // TODO: reload only one
            self.service.rowSelected(id: row.id) { dataModel in
                table.localData = dataModel
            }
        }
    }

    @objc func didTapDone() {
        service.didTapDone(name: nameTextField.text) { [unowned self] in self.dismiss() }
    }

}

extension AccountGroupEditVC {
    class Service: ClassService {

        private var accounts = [String: Account]()
        private var dataModel: DataModelProtocol {
            return DataModel(self.accounts.map {DataModelRow(
                id: $0.key,
                name: $0.value.name,
                desc: "\($0.value.amount ?? 0)",
                accessory: self.selectedAccounts.contains($0.key) ? 3 : 0,
                filter: $0.value.type?.rawValue)
            })
        }
        var accountGroup: String?
        var selectedAccounts: Set<String> = []

        func getData(forId id: String? = nil, completion: @escaping ((DataModelProtocol) -> Void)) {
            data.setListnerToAccounts(for: self.id) {[unowned self] data in
                for (id, account, changeType) in data {
                    switch changeType {
                    case .added, .modified:
                        self.accounts[id] = account
                        if account.groups?[self.accountGroup ?? ""] != nil {
                            self.selectedAccounts.insert(id)
                        }
                    case .removed:
                        self.accounts.removeValue(forKey: id)
                        self.selectedAccounts.remove(id)
                    }
                }
                completion(self.dataModel)
            }
        }

        func rowSelected(id: String?, completion: ((DataModelProtocol) -> Void)? = nil) {
            guard let id = id else { return }
            if selectedAccounts.contains(id) {
                selectedAccounts.remove(id)
            } else {
                selectedAccounts.insert(id)
            }
            completion?(self.dataModel)
        }

        func didTapDone(name: String?, completion: (() -> Void)? = nil) {
            guard let name = name else { return }
            let accounts = self.accounts.filter {
                selectedAccounts.contains($0.key)
            }.map {($0.key, $0.value.name ?? "")
            }
            data.createAccountGroup(named: name, withAccounts: accounts)
            completion?()
        }

    }

}
