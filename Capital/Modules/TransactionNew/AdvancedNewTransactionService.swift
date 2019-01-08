import UIKit
//FIXME: Switch to import Swift or Foundation

protocol AdvancedNewTransactionServiceProtocol: class {
    var view: AdvancedNewTransactionVCProtocol? {get set}
    func viewDidLoad(_ view: AdvancedNewTransactionVCProtocol)
    func didSelect(_ item: TransactionItem)
    func didChoose(transactionItem: TransactionItem, with value: Any?)
    func didScroll()
    func didTapDone()
}

class AdvancedNewTransactionService: ClassService, AdvancedNewTransactionServiceProtocol {

    weak var view: AdvancedNewTransactionVCProtocol?
    private var fromAccountId: String?
    private var toAccountId: String?
    private var amount: Int? {didSet {transactionItemsDesc[.amount] = "\(amount ?? 0)"}}
    private var date: Date? {didSet {
        transactionItemsDesc[.date] = date?.string
        transactionItemsDesc[.dateSelection] = date?.string
        }
    }
    private var approvalMode: FinTransaction.ApprovalMode? {
        didSet {transactionItemsDesc[.approvalMode] = approvalMode?.name}
    }
    private var recurrenceFrequency = RecurrenceFrequency.never {
        didSet {transactionItemsDesc[.recurrenceFrequency] = recurrenceFrequency.name}
    }
    private var recurrenceEndDate: Date? {didSet {
        transactionItemsDesc[.recurrenceEnd] = recurrenceEndDate?.string
        transactionItemsDesc[.recurrenceEndDate] = recurrenceEndDate?.string
        }
    }
    /// Defines which menu items to show
    private var transactionItems: [TransactionItem] = [.from, .amount, .to, .date, .recurrenceFrequency]
    /// Provides description (label / text field to the right in the cell) for the transaction items
    private var transactionItemsDesc = [TransactionItem: String]()
    /// Provides date suitable for DataModel initialization
    private var tableData: [(id: String?, name: String?, desc: String?, height: CGFloat?)] {
        return transactionItems.map {
            (id: $0.rawValue, name: $0.name, desc: transactionItemsDesc[$0], height: $0.height)
        }
    }

    // MARK: - Setup methods
    func viewDidLoad(_ view: AdvancedNewTransactionVCProtocol) {
        self.view = view
        getData()
    }

    func getData(for indexPath: IndexPath? = nil) {
        view?.tableData = DataModel(tableData)
        view?.reloadData(for: indexPath)
    }

    func getData(for transactionItem: TransactionItem) {
        guard let indexPath = transactionItems.firstIndex(of: transactionItem) else {return}
        getData(for: IndexPath(row: indexPath, section: 0))
    }

    func didSelect(_ item: TransactionItem) {
        if item != .date {hide(.dateSelection)}
        if item != .recurrenceEnd {hide(.recurrenceEndDate)}
        let action: ((Any?) -> Void) = {id in self.didChoose(transactionItem: item, with: id)}

        switch item {
        case .from, .to:
            view?.push(AccountSelectorVC(action))
            hide(.dateSelection)
        case .amount:
            view?.setAmountFieldFirstResponder()
        case .date:
            if transactionItems.contains(.dateSelection) {
                hide(.dateSelection)
            } else {
                insert(.dateSelection, after: .date)
            }
        case .dateSelection:
            fatalError()
        case .approvalMode:
            let sourceData: () -> (DataModel) = {
                return DataModel(FinTransaction.ApprovalMode.allCases.map {
                    (id: "\($0.rawValue)", name: $0.name)
                })
            }
            view?.push(EnumValuesSelectorVC((sourceData: sourceData, selectionAction: action)))
        case .recurrenceFrequency:
            view?.push(RecurrenceFrequencySelectorVC(action))
        case .recurrenceEnd:
            if transactionItems.contains(.recurrenceEndDate) {hide(.recurrenceEndDate)} else {
                insert(.recurrenceEndDate, after: .recurrenceEnd)
            }
        case .recurrenceEndDate:
            fatalError()
        }
    }

    // MARK: - Actions on selection of Transaction items
    func didChoose(transactionItem: TransactionItem, with value: Any?) {
        switch transactionItem {
        case .from:
            fromAccountId = (value as? AccountInfo)?.id
            transactionItemsDesc[.from] = (value as? AccountInfo)?.name
            getData(for: transactionItem)
        case .to:
            toAccountId = (value as? AccountInfo)?.id
            transactionItemsDesc[.to] = (value as? AccountInfo)?.name
            getData(for: transactionItem)
        case .amount:
            self.amount = Int(value as? String ?? "")
            getData(for: transactionItem)
        case .date:
            fatalError()
        case .dateSelection:
            self.date = value as? Date
            if let date = value as? Date, date > Date() {
                if !transactionItems.contains(.approvalMode) {insert(.approvalMode, after: .dateSelection)}
            } else {
                hide(.approvalMode)
            }
            getData(for: .date)
        case .approvalMode:
            guard let enumId = value as? String, let rawValue = Int(enumId),
                let approvalMode = FinTransaction.ApprovalMode(rawValue: rawValue) else {return}
            self.approvalMode = approvalMode
            getData(for: transactionItem)
        case .recurrenceFrequency:
            guard let enumId = value  as? String, let rawValue = Int(enumId),
                let recurrenceFrequency = RecurrenceFrequency(rawValue: rawValue) else {return}
            self.recurrenceFrequency = recurrenceFrequency
            getData(for: .recurrenceFrequency)
            if recurrenceFrequency == .never {hide(.recurrenceEnd)} else {
                if !transactionItems.contains(.recurrenceEnd) {
                    insert(.recurrenceEnd, after: .recurrenceFrequency)
                }
            }
        case .recurrenceEnd:
            fatalError()
        case .recurrenceEndDate:
            self.recurrenceEndDate = value as? Date
            getData(for: .recurrenceEnd)
        }
    }

    // MARK: - Miscellaneous

    func didTapDone() {
        view?.endEditing(force: true)
        guard let fromId = fromAccountId, let fromName = transactionItemsDesc[.from],
            let toId = toAccountId, let toName = transactionItemsDesc[.to],
            let amountV = amount  else {return}
        data.createTransaction(from: (fromId, fromName), to: (toId, toName), amount: amountV,
                               date: date, approvalMode: approvalMode,
                               recurrenceFrequency: recurrenceFrequency,
                               recurrenceEnd: recurrenceEndDate) {_ in
            //            self.view?.dismissNavigationViewController() //FIXME: should clear the data
        }

    }

    func didScroll() {
        //TODO: don't hide selected cell details
        hide(.dateSelection)
        view?.endEditing(force: true)
    }

    func insert(_ transactionItem: TransactionItem, after place: TransactionItem) {
        guard let index = transactionItems.firstIndex(of: place) else {return}
        transactionItems.insert(transactionItem, at: index+1)
        view?.tableData = DataModel(tableData)
        view?.insertRows(at: [IndexPath(row: index+1, section: 0)], with: .fade)
    }

    func hide(_ item: TransactionItem) {
        guard let index = transactionItems.firstIndex(of: item) else {return}
        transactionItems.remove(at: index)
        view?.tableData = DataModel(tableData)
        view?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }

}
