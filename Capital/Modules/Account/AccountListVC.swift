/// View Controller showing list of Accounts
internal final class AccountListVC: ViewController {
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        let service = Service()
        var selectedSegment = 0
        title = "Accounts"
        let table: SimpleTableProtocol = SimpleTable()
        let segmentedControl: SegmentedControlProtocol =
            SegmentedControl(AccountType.allCases.map { $0.name }) {[unowned table] segmentIndex in
            table.filter = { $0.filter as? Int == segmentIndex }
            selectedSegment = segmentIndex
            }
        table.filter = { $0.filter as? Int == 0 }
        service.getData { dataModel in table.localData = dataModel }
        navigationItem.rightBarButtonItem = BarButtonItem(title: "New") {[unowned self] in
            self.navigationController?.pushViewController(AccountNewVC(selectedSegment), animated: true)
        }

        table.didSelect = {[unowned self] row, _ in
            let viewController = AccountTransactionsVC((row.texts[.id], row.texts[.name]))
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        view.add(views: ["t": table as? UIView, "sc": segmentedControl as? UIView],
                 withConstraints: ["H:|[t]|", "H:|-20-[sc]-20-|", "V:|-80-[sc(31)]-5-[t]|"])
    }
}
/// Extension to provide view controller with service class
extension AccountListVC {
    /// Service class for `AccountListVC`
    private class Service: ClassService {
        /// Accounts downloaded from online database
        private var accounts = [String: Account]()
        /// Loads data for view controller
        ///
        /// - Parameter completion: action to perform after data is loaded
        internal func getData(completion: @escaping ((DataModelProtocol) -> Void)) {
            data.setListnerToAccounts(for: self.id) { data in
                for (id, account, changeType) in data {
                    switch changeType {
                    case .added, .modified:
                        self.accounts[id] = account

                    case .removed:
                        self.accounts.removeValue(forKey: id)
                    }
                }
                let rows: [DataModelRowProtocol] = self.accounts.map {
                    DataModelRow(
                        texts: [
                            .id: $0.key,
                            .name: $0.value.name ?? "",
                            .desc: "\($0.value.amount ?? 0) (\($0.value.min?.amount ?? $0.value.amount ?? 0))"
                        ],
                        filter: $0.value.typeId ?? 4
                    )
//                    DataModelRow(id: $0.key, name: $0.value.name, desc: "\($0.value.amount ?? 0) (\($0.value.min?.amount ?? $0.value.amount ?? 0))", filter: $0.value.typeId ?? 4)
                }
                completion(DataModel(rows))
            }
        }

        /// Deletes account group calling `Data.shared` Singleton
        ///
        /// - Parameter row: table row with AccountGroup to delete
        internal func remove(_ row: DataModelRowProtocol?) {
            guard let id = row?.texts[.id] else {
                return
            }
            data.delete(.group, withId: id)
        }
    }
}
