/// View controller showing `AccountGroup`s list
internal final class AccountGroupsVC: ViewController {
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        let service = Service()
        let table: SimpleTableWithSwipeProtocol = SimpleTableWithSwipe()
        service.getData { dataModel in table.localData = dataModel }
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        self.title = "DashBoard"
        navigationItem.rightBarButtonItem = BarButtonItem(title: "New") {[unowned self] in
            self.navigationController?.pushViewController(AccountGroupEditVC(), animated: true)
        }
        table.swipeLeftAction = { [unowned service] row in service.remove(row) }
        table.swipeLeftLabel = "Delete"
        table.didSelect = {[unowned self] row, _ in
            self.navigationController?.pushViewController(
                AccountGroupDetailVC((row.texts[.id], row.texts[.name])), animated: true)
        }
    }
}
/// Extension to provide view controller with service class
extension AccountGroupsVC {
    /// Service class for `AccountGroupsVC`
    internal final class Service: ClassService {
        /// Accounts of AccountGroup downloaded from online database
        private var accountGroups = [String: AccountGroup]()

        /// Loads data for view controller
        ///
        /// - Parameter completion: action to perform after data is loaded
        internal func getData(completion: @escaping ((DataModelProtocol) -> Void)) {
            data.setListnerToAccountGroup(for: self.id) { data in
                for (id, accountGroup, changeType) in data {
                    switch changeType {
                    case .added, .modified:
                        self.accountGroups[id] = accountGroup

                    case .removed:
                        self.accountGroups.removeValue(forKey: id)
                    }
                }
                let rows = self.accountGroups.map {
                    DataModelRow(texts:
                        [
                        .id: $0.key,
                        .name: $0.value.name ?? "",
                        .desc: "\($0.value.amount ?? 0)"
                        ])
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
