/// View controller for `Account`
internal final class AccountSelectorVC: ViewController {
    private let service = Service()
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Account"

        let table: SimpleTableWithSwipeProtocol = SimpleTableWithSwipe()
        let segmentedControl: SegmentedControlProtocol
        segmentedControl = SegmentedControl(AccountType.allCases.map { $0.name }) { index in
            table.filter = { $0.filter as? Int == index }
        }
        table.filter = { $0.filter as? Int == 0 }
        service.getData { dataModel in table.localData = dataModel }

        view.add(views: ["t": table as? UIView, "sc": segmentedControl as? UIView],
                 withConstraints: ["H:|[t]|", "H:|-20-[sc]-20-|", "V:|-80-[sc(31)]-5-[t]|"])

        let selectionAction = data as? ((Any?) -> Void)
        table.didSelect = { row, _ in
            selectionAction?((row.texts[.id], row.texts[.name]))
            self.dismiss()
        }
    }
}
/// Extension to provide view controller with service class
extension AccountSelectorVC {
    private class Service: ClassService {
        /// Accounts downloaded from online database
        private var accounts = [String: Account]()
        /// Accounts transformed to DataModel for the view controller table source
        private var dataModel: DataModelProtocol {
            let dataModelSource = self.accounts.map {
                DataModelRow(
                    texts: [
                    .id: $0.key,
                    .name: $0.value.name ?? "",
                    .desc: "\($0.value.amount ?? 0)"
                    ],
                    filter: $0.value.type?.rawValue
                )
            }
            return DataModel(dataModelSource)
        }

        /// Loads data for view controller
        ///
        /// - Parameter completion: action to perform after data is loaded
        internal func getData(completion: @escaping ((DataModelProtocol) -> Void)) {
            data.setListnerToAccounts(for: self.id) {[unowned self] data in
                for (id, account, changeType) in data {
                    switch changeType {
                    case .added, .modified:
                        self.accounts[id] = account

                    case .removed:
                        self.accounts.removeValue(forKey: id)
                    }
                }
                completion(self.dataModel)
            }
        }
    }
}
