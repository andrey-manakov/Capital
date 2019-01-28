/// View Controller showing FinTransactions of selected Account
internal final class AccountTransactionsVC: ViewController {
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        let data = self.data as? AccountInfo
        let id = data?.id
        title = data?.name
        let table: TransactionsTableProtocol = TransactionsTable()
        let service = AccountTransactionsVC.Service()
        service.getData(withId: id) { dataModel in table.localData = dataModel }

        navigationItem.rightBarButtonItem = BarButtonItem(title: "Edit") {
            self.navigationController?.pushViewController(AccountDetailVC(id), animated: true)
        }

        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])

        // MARK: transaction table setup
        table.swipeLeftAction = {
            row in service.deleteTransaction(withId: row?.texts[.id])
        }
        table.swipeLeftLabel = "Delete"
        table.swipeRightAction = {
            row in service.deleteTransaction(withId: row?.texts[.id])
        }
        table.swipeRightLabel = "Approve"
    }
}
/// Extension to provide view controller with service class
extension AccountTransactionsVC {
    /// Service class for `AccountTransactionsVC`
    private class Service: ClassService {
        private var transactions = [String: FinTransaction]()

        /// Loads data for view controller
        ///
        /// - Parameter completion: action to perform after data is loaded
        func getData(withId id: String?, completion: @escaping ((DataModelProtocol) -> Void)) {
            guard let id = id else {
                return
            }
            data.setListnersToTransactionsOfAccount(withId: id, for: self.id) {[unowned self] data in
                for (id, transaction, changeType) in data {
                    switch changeType {
                    case .added, .modified:
                        self.transactions[id] = transaction

                    case .removed:
                        self.transactions.removeValue(forKey: id)
                    }
                }
                let rows: [DataModelRowProtocol] = self.transactions.map {
                    DataModelRow(texts:
                        [
                        .id: $0.key,
                        .left: $0.value.dateText,
                        .up: $0.value.from?.name ?? "",
                        .down: $0.value.to?.name ?? "",
                        .right: "\($0.value.amount ?? 0)"
                        ])
//                    DataModelRow(id: $0.key, left: $0.value.dateText, up: $0.value.from?.name, down: $0.value.to?.name, right: "\($0.value.amount ?? 0)")
                }
                completion(DataModel(rows))
//                completion(DataModel(self.transactions.map {(
//                    id: $0.key,
//                    left: $0.value.dateText,
//                    up: $0.value.from?.name,
//                    down: $0.value.to?.name,
//                    right: "\($0.value.amount ?? 0)")
//                }))
            }
        }

        /// Deletes `FinTransaction`
        ///
        /// - Parameters:
        ///   - id: `FinTransaction` id to delete
        ///   - completion: action to perform after delete
        func deleteTransaction(withId id: String?, completion: (() -> Void)? = nil) {
            // FIXME: Add implementation
        }

        /// Approves `FinTransaction` setting `FinTransaction.isApproved` property to true and making relevant changes to `Account` amounts
        ///
        /// - Parameters:
        ///   - id: `FinTransaction` is to approve
        ///   - completion: action to perform after `FinTransaction` approval
        func approveTransaction(withId id: String?, completion: (() -> Void)? = nil) {
            // FIXME: Add implementation
        }
    }
}
