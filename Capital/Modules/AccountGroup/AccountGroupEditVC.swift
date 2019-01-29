/// View controller which allows to edit `AccountGroup`
internal final class AccountGroupEditVC: ViewController {
    /// Service of view controller to perform actions on data
    private let service = Service()
    /// Text field for `AccountGroup` name
    private let nameTextField: TextFieldProtocol = SimpleTextField("Account Group Name")
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
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
        view.add(views:
            [
                "nm": nameTextField as? UIView, "sc": segmentedControl as? UIView,
                "tbl": table as? UIView
            ],
                 withConstraints:
            [
                "H:|-15-[nm]-15-|", "H:|-20-[sc]-20-|", "H:|[tbl]|",
                "V:|-80-[nm(31)]-20-[sc]-10-[tbl]|"
            ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self, action: #selector(didTapDone))
        table.didSelect = {[unowned self] row, _ in
            // TODO: reload only one
            self.service.rowSelected(id: row.texts[.id]) { dataModel in
                table.localData = dataModel
            }
        }
    }
    /// Triggered when done button is tapped, calls `AccountGroupEditVC.Service.didTapDone`
    @objc internal func didTapDone() {
        service.didTapDone(name: nameTextField.text) { [unowned self] in self.dismiss() }
    }
}
/// Extension to provide view controller with service class
extension AccountGroupEditVC {
    /// Service class for `AccountGroupEditVC`
    private class Service: ClassService {
        /// Accounts of AccountGroup downloaded from online database
        private var accounts = [String: Account]()
        /// Accounts transformed to DataModel for the view controller table source
        private var dataModel: DataModelProtocol {
            return DataModel(self.accounts.map {
                DataModelRow(
                    texts: [
                        .id: $0.key,
                        .name: $0.value.name ?? "",
                        .desc: "\($0.value.amount ?? 0)"
                    ],
                    accessory: self.selectedAccounts.contains($0.key) ? 3 : 0,
                    filter: $0.value.type?.rawValue)
            })
        }
        /// `AccountGroup` selected for the view controller source
        internal var accountGroup: String?
        /// `Account`s selected to belong to `AccountGroup` being edited
        internal var selectedAccounts: Set<String> = []

        /// Loads data for view controller
        ///
        /// - Parameters:
        ///   - id: `AccountGroup` id
        ///   - completion: action to perform after data is loaded
        func getData(forId id: String? = nil, completion: @escaping ((DataModelProtocol) -> Void)) {
            // check whether unowned self is needed in closure
            data.setListnerToAccounts(for: self.id) { data in
                for (id, account, changeType) in data {
                    switch changeType {
                    case .added, .modified:
                        self.accounts[id] = account
                        if account.groups[self.accountGroup ?? ""] != nil {
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

        /// Processes action of account selection / deselection (which belong to `AccountGroup`)
        ///
        /// - Parameters:
        ///   - id: `Account` id selected
        ///   - completion: action to perform after account selected / deselected
        func rowSelected(id: String?, completion: ((DataModelProtocol) -> Void)? = nil) {
            guard let id = id else {
                return
            }
            if selectedAccounts.contains(id) {
                selectedAccounts.remove(id)
            } else {
                selectedAccounts.insert(id)
            }
            completion?(self.dataModel)
        }

        /// Triggered when done button is tapped, calls Data Singleton to update `AccountGroup` with new values
        ///
        /// - Parameters:
        ///   - name: new name of `Accountgroup`
        ///   - completion: action to perform after `AccountGroup` update
        func didTapDone(name: String?, completion: (() -> Void)? = nil) {
            guard let name = name else {
                return
            }
            let accounts = self.accounts.filter {
                selectedAccounts.contains($0.key)
            }.map {($0.key, $0.value.name ?? "")
            }
            data.createAccountGroup(named: name, withAccounts: accounts)
            completion?()
        }
    }
}
