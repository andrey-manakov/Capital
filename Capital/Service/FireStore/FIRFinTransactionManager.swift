protocol FIRFinTransactionManagerProtocol: class {
    func createTransaction(from: AccountInfo?, to: AccountInfo?, amount: Int?, date: Date?, approvalMode: FinTransaction.ApprovalMode?, recurrenceFrequency: RecurrenceFrequency?, recurrenceEnd: Date?, completion: ((String?)->Void)?)
}

extension FIRFinTransactionManager: FireStoreCompletionProtocol, FireStoreGettersProtocol, MiscFunctionsProtocol {}

class FIRFinTransactionManager: FIRManager, FIRFinTransactionManagerProtocol {
    /// Singlton
    static var shared: FIRFinTransactionManagerProtocol = FIRFinTransactionManager()
    private override init() {}

    /// Creates transaction in FireStore date base, including recurrent transactions, updates account values if transactions are in the past
    ///
    /// - Parameters:
    ///   - from: account id **from** which transaction amount is changed
    ///   - to: account id **to** which transaction amount is changed
    ///   - amount: monetary amount of the transaction
    ///   - date: date when transaction take place
    ///   - approvalMode: the way **future** transaction is processed when the transaction ````date```` comes
    ///   - recurrenceFrequency: for transaction to be repeated in the future, the repeating frequency
    ///   - recurrenceEnd: date when recurrency should finish
    ///   - completion: action to perform after function finishes execution, for now it only works for successes
    ///
    /// * For now it doesn't limit the receurrence End date, but Transactions in FireStore are limited to 400 operations, so the limit should be intoduced here
    /// * The creation is performed the following way
    ///     * read account amounts from FireStore
    ///     * create transactions
    ///     * update account amounts
    func createTransaction(from: AccountInfo?, to: AccountInfo?, amount: Int?, date: Date? = Date(), approvalMode: FinTransaction.ApprovalMode? = nil, recurrenceFrequency: RecurrenceFrequency? = nil, recurrenceEnd: Date? = nil, completion: ((String?)->Void)? = nil) {

        guard let ref = ref, let from = from, let to = to, let amount = amount else {return}

        let batch = self.db.batch()

        var date: Date? = date ?? Date()
        var approvedAmount = 0
        var amountChange = [String: Int]()
        var i = 0
        var originalTransaction: DocumentReference?
        while date != nil {// && !(date!.isAfter(recurrenceEnd ?? Date()))
            let newRef = ref.collection(DataObjectType.transaction.rawValue).document()
            if i == 0 {originalTransaction = newRef}
            let approved = date ?? Date() <= Date()
            batch.setData([
                FinTransaction.Fields.amount.rawValue: amount,
                FinTransaction.Fields.approvalMode.rawValue: approvalMode?.rawValue as Any,
                FinTransaction.Fields.date.rawValue: date as Any ,
                FinTransaction.Fields.from.rawValue: [
                    FinTransaction.Fields.From.id.rawValue: from.id, FinTransaction.Fields.From.name.rawValue: from.name],
                FinTransaction.Fields.to.rawValue: [
                    FinTransaction.Fields.To.id.rawValue: to.id, FinTransaction.Fields.To.name.rawValue: to.name],
                FinTransaction.Fields.isApproved.rawValue: approved,
                FinTransaction.Fields.parent.rawValue: NSNull(),
                FinTransaction.Fields.recurrenceEnd.rawValue: recurrenceEnd ?? NSNull(),
                FinTransaction.Fields.recurrenceFrequency.rawValue: recurrenceFrequency?.rawValue ?? NSNull()], forDocument: newRef)
            if approved {approvedAmount += amount} else {
                if let date = date {amountChange[date.str("yyyy-MM-dd")] = amount}
            }
            date = nextDate(from: date, recurrenceFrequency: recurrenceFrequency)
            if recurrenceEnd == nil || date == nil || date!.isAfter(recurrenceEnd!) {date = nil}
            i += 1
            if i == 366 {fatalError()}
        }

        batch.setData([
            LogFields.from.rawValue: [
                FinTransaction.Fields.From.id.rawValue: from.id, FinTransaction.Fields.From.name.rawValue: from.name],
            LogFields.to.rawValue: [
                FinTransaction.Fields.To.id.rawValue: to.id, FinTransaction.Fields.To.name.rawValue: to.name],
            LogFields.timestamp.rawValue: FieldValue.serverTimestamp(),
            LogFields.transaction.rawValue: originalTransaction as Any,
            LogFields.approvedAmount.rawValue: approvedAmount,
            LogFields.recurrenceChanges.rawValue: amountChange],
                      forDocument: ref.collection(LogFields.logCollection).document())
        batch.commit(completion: fireStoreCompletion)
    }
    enum LogFields: String {
        static let logCollection = "change"
        case type, from, to, timestamp, transaction, approvedAmount, recurrenceChanges

        enum LogType: String {
            case approved, recurrence
        }
    }
}
