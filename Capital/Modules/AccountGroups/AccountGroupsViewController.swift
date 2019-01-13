internal final class AccountGroupsViewController: ViewController {
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
                AccountGroupDetailVC((row.id, row.name)), animated: true)
        }
    }
}

extension AccountGroupsViewController {
    internal final class Service: ClassService {
        private var accountGroups = [String: AccountGroup]() // {didSet{print(accountGroups)}}

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
                let dataModel = DataModel(self.accountGroups.map {
                    (id: $0.key, name: $0.value.name, desc: "\($0.value.amount ?? 0)")
                })
                completion(dataModel)
            }
        }

        internal func remove(_ row: DataModelRowProtocol?) {
            guard let id = row?.id else {
                return
            }
            data.delete(.group, withId: id)
        }
    }
}
