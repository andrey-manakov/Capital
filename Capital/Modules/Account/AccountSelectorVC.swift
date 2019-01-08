class AccountSelectorVC: ViewController {
    let service = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Account"

        let table: SimpleTableWithSwipeProtocol = SimpleTableWithSwipe()
        let segmentedControl: SegmentedControlProtocol
        segmentedControl = SegmentedControl(AccountType.allCases.map {$0.name}) {index in
            table.filter = {$0.filter as? Int == index}
        }
        table.filter = {$0.filter as? Int == 0}
        service.getData { dataModel in table.localData = dataModel}

        view.add(subViews: ["t": table as? UIView, "sc": segmentedControl as? UIView],
                 withConstraints: ["H:|[t]|", "H:|-20-[sc]-20-|", "V:|-80-[sc(31)]-5-[t]|"])

        let selectionAction = data as? ((Any?) -> Void)
        table.didSelect = {row, _ in
            selectionAction?((row.id, row.name))
            self.dismiss()
        }
    }

}

extension AccountSelectorVC {
    class Service: ClassService {
        private var accounts = [String: Account]()
        private var dataModel: DataModelProtocol {return DataModel(self.accounts.map {DataModelRow(
            id: $0.key,
            name: $0.value.name,
            desc: "\($0.value.amount ?? 0)",
            filter: $0.value.type?.rawValue)})}

        func getData(completion: @escaping ((DataModelProtocol) -> Void)) {
            data.setListnerToAccounts(for: self.id) {[unowned self] data in
                for (id, account, changeType) in data {
                    switch changeType {
                    case .added, .modified: self.accounts[id] = account
                    case .removed: self.accounts.removeValue(forKey: id)
                    }
                }
                completion(self.dataModel)
            }
        }
    }

}
