internal typealias SendFinTransactionResult = (approvedAmount: Int, dynamics: [Date: Int])
internal protocol FIRFinTransactionManagerProtocolOld: AnyObject {
    func createTransaction(
        from: AccountInfo?, to: AccountInfo?, amount: Int?, date: Date?,
        approvalMode: FinTransaction.ApprovalMode?, recurrenceFrequency: RecurrenceFrequency?,
        recurrenceEnd: Date?, completion: ((String?) -> Void)?
    )
    func create(_ finTransaction: FinTransaction, completion: ((String?) -> Void)?)
    func sendFinTransaction(
        to fsTransaction: Transaction, from: AccountInfo?, to: AccountInfo?, amount: Int?,
        date: Date?, approvalMode: FinTransaction.ApprovalMode?,
        recurrenceFrequency: RecurrenceFrequency?, recurrenceEnd: Date?, parent: String?,
        result: SendFinTransactionResult
        ) -> SendFinTransactionResult
}

extension FIRFinTransactionManagerProtocolOld {
    internal func sendFinTransaction(
        to fsTransaction: Transaction,
        from: AccountInfo?,
        to: AccountInfo?,
        amount: Int?
        ) -> SendFinTransactionResult {
        return sendFinTransaction(
            to: fsTransaction,
            from: from,
            to: to,
            amount: amount,
            date: nil,
            approvalMode: nil,
            recurrenceFrequency: nil,
            recurrenceEnd: nil,
            parent: nil,
            result: (0, [Date: Int]())
        )
    }
}

extension FIRFinTransactionManagerOld: FireStoreCompletionProtocol, FireStoreGettersProtocol {}
extension FIRFinTransactionManagerOld: MiscFunctionsProtocol {}

internal final class FIRFinTransactionManagerOld: FIRManager, FIRFinTransactionManagerProtocolOld {
    /// Singlton
    internal static var shared: FIRFinTransactionManagerProtocolOld = FIRFinTransactionManagerOld()

    override private init() {}

    // TODO: consider add error processing to completion
    // FIXME: introduce limit to number of recurrent operations
    /// Creates transaction in FireStore date base, including recurrent transactions,
    /// updates account values if transactions are in the past
    ///
    /// - Parameters:
    ///   - from: account id **from** which transaction amount is changed
    ///   - to: account id **to** which transaction amount is changed
    ///   - amount: monetary amount of the transaction
    ///   - date: date when transaction take place
    ///   - approvalMode: the way **future** transaction is processed when the transaction ````date```` comes
    ///   - recurrenceFrequency: for transaction to be repeated in the future, the repeating frequency
    ///   - recurrenceEnd: date when recurrency should finish
    ///   - completion: action to perform after function finishes execution,
    ///     for now it only works for successes
    ///
    /// * For now it doesn't limit the receurrence End date,
    ///   but Transactions in FireStore are limited to 400 operations, so the limit should be intoduced here
    /// * The creation is performed the following way
    ///     * read account amounts from FireStore
    ///     * create transactions
    ///     * update account amounts
    internal func createTransaction(
        from: AccountInfo?, to: AccountInfo?, amount: Int?, date: Date? = Date(),
        approvalMode: FinTransaction.ApprovalMode? = nil,
        recurrenceFrequency: RecurrenceFrequency? = nil,
        recurrenceEnd: Date? = nil, completion: ((String?) -> Void)? = nil
        ) {
        guard let ref = ref, let from = from, let to = to, let amount = amount else {
            return
        }

        fireDB.runTransaction({ fsTransaction, errorPointer -> Any? in
            // read account amounts from FireStore
            guard
                let fromAccount = self.getAccount(withId: from.id, for: fsTransaction, with: errorPointer),
                let toAccount = self.getAccount(withId: to.id, for: fsTransaction, with: errorPointer)//,
//                let fromAccountDynamics = self.getAccountDynamics(withId: from.id, for: fsTransaction, with: errorPointer),
//                let toAccountDynamics = self.getAccountDynamics(withId: to.id, for: fsTransaction, with: errorPointer)
            else {
                    return nil
            }
            // create transactions
            let sendTransactionResult: SendFinTransactionResult
            sendTransactionResult = self.sendFinTransaction(
                to: fsTransaction,
                from: (from.id, fromAccount.name ?? ""),
                to: (to.id, toAccount.name ?? ""),
                amount: amount, date: date,
                approvalMode: approvalMode,
                recurrenceFrequency: recurrenceFrequency,
                recurrenceEnd: recurrenceEnd)

            let approvedAmount = sendTransactionResult.approvedAmount
            // update account amounts
            for (id, account) in [from.id: fromAccount, to.id: toAccount] {
                let coef: Int = ((account.type?.active ?? true) ? 1 : -1) * (id == to.id ? 1 : -1)
                fsTransaction.updateData(
                    [Account.fields.amount: (account.amount ?? 0) + coef * approvedAmount],
                    forDocument: ref.collection(DataObjectType.account.rawValue).document(id))
            }
            return { print("Transaction created") }
        }, completion: fireStoreCompletion)
    }

    internal func create(_ finTransaction: FinTransaction, completion: ((String?) -> Void)? = nil
        ) {
        guard let ref = ref, let from = finTransaction.from, let to = finTransaction.to, let amount = finTransaction.amount else {
            return
        }

        fireDB.runTransaction({ fsTransaction, errorPointer -> Any? in
            // read account amounts from FireStore
            guard
                let fromAccount = self.getAccount(withId: from.id, for: fsTransaction, with: errorPointer),
                let toAccount = self.getAccount(withId: to.id, for: fsTransaction, with: errorPointer)// ,
                //                let fromAccountDynamics = self.getAccountDynamics(withId: from.id, for: fsTransaction, with: errorPointer),
                //                let toAccountDynamics = self.getAccountDynamics(withId: to.id, for: fsTransaction, with: errorPointer)
                else {
                    return nil
            }
            // create transactions
            let sendTransactionResult: SendFinTransactionResult
            sendTransactionResult = self.sendFinTransaction(
                to: fsTransaction,
                from: (from.id, fromAccount.name ?? ""),
                to: (to.id, toAccount.name ?? ""),
                amount: amount, date: finTransaction.date,
                approvalMode: finTransaction.approvalMode,
                recurrenceFrequency: finTransaction.recurrenceFrequency,
                recurrenceEnd: finTransaction.recurrenceEnd)

            let approvedAmount = sendTransactionResult.approvedAmount
            // update account amounts
            for (id, account) in [from.id: fromAccount, to.id: toAccount] {
                let coef: Int = ((account.type?.active ?? true) ? 1 : -1) * (id == to.id ? 1 : -1)
                fsTransaction.updateData(
                    [Account.fields.amount: (account.amount ?? 0) + coef * approvedAmount],
                    forDocument: ref.collection(DataObjectType.account.rawValue).document(id))
            }
            return { print("Transaction created") }
        }, completion: fireStoreCompletion)
    }

    /// Adds FinTransaction to operations in FireStore transaction, returns id of new FinTransaction
    ///
    /// - Parameters:
    ///   - fsTransaction: FireStore transaction to which function adds transaction
    ///   - from: account id **from** which transaction amount is changed
    ///   - to: account id **to** which transaction amount is changed
    ///   - amount: monetary amount of the transaction
    ///   - date: date when transaction take place
    ///   - approvalMode: the way **future** transaction is processed when the transaction ````date```` comes
    ///   - recurrenceFrequency: for transaction to be repeated in the future, the repeating frequency
    ///   - recurrenceEnd: date when recurrency should finish
    ///   - completion: action to perform after function finishes execution,
    ///     for now it only works for successes
    ///   - parent: id of parent transaction - transaction which is based for recurrent transactions,
    ///     this parent prpoerty is used to be able to get the group of recurrent transactions
    ///   - approvedAmount: amount returned - the sum of amounts of approved transactions (in the past),
    ///     used to update account values
    /// - Returns: approvedAmount(Int) - the sum of amounts of approved transactions (in the past),
    ///     used to update account values
    internal func sendFinTransaction(
        to fsTransaction: Transaction,
        from: AccountInfo?,
        to: AccountInfo?,
        amount: Int?,
        date: Date? = Date(),
        approvalMode: FinTransaction.ApprovalMode? = nil,
        recurrenceFrequency: RecurrenceFrequency? = nil,
        recurrenceEnd: Date? = nil,
        parent: String? = nil,
        result: SendFinTransactionResult = (0, [Date: Int]())) -> SendFinTransactionResult {
        guard
            let newFinTransactionRef = self.ref?.collection(DataObjectType.transaction.rawValue).document(),
            let from = from,
//            let fromDynamics = self.ref?.collection(DataObjectType.dynamics.rawValue).document(),
            let to = to,
            let amount = amount else { return result }
        let date = date ?? Date()
        // TODO: switch to fields
        fsTransaction.setData([
            FinTransaction.Fields.from.rawValue:
                [FinTransaction.Fields.From.id.rawValue: from.id,
                 FinTransaction.Fields.From.name.rawValue: from.name] as Any,
            FinTransaction.Fields.to.rawValue:
                [FinTransaction.Fields.To.id.rawValue: to.id,
                 FinTransaction.Fields.To.name.rawValue: to.name] as Any,
            FinTransaction.Fields.amount.rawValue: amount as Any,
            FinTransaction.Fields.date.rawValue: Timestamp(date: date),
            FinTransaction.Fields.isApproved.rawValue: date <= Date() ? true : false,
            FinTransaction.Fields.approvalMode.rawValue: approvalMode?.rawValue as Any,
            FinTransaction.Fields.recurrenceFrequency.rawValue:
                recurrenceFrequency == nil ? NSNull() : recurrenceFrequency!.rawValue,
            FinTransaction.Fields.recurrenceEnd.rawValue:
                recurrenceEnd == nil ? NSNull() : Timestamp(date: recurrenceEnd!)
        ], forDocument: newFinTransactionRef)
        let approvedAmount: Int
        var dynamics: [Date: Int] = result.dynamics
        if date <= Date() {
            approvedAmount = result.approvedAmount + amount
        } else {
            approvedAmount = result.approvedAmount
            dynamics[date] = (dynamics[date] ?? 0) + amount
        }
//        let approvedAmount = date < Date() ? result.approvedAmount + amount : result.approvedAmount
        // TODO: consider default recurrence end
        if let recurrenceFrequency = recurrenceFrequency, recurrenceFrequency != .never,
            let nextDate = nextDate(from: date, recurrenceFrequency: recurrenceFrequency),
            let recurrenceEnd = recurrenceEnd, nextDate <= recurrenceEnd {
            return sendFinTransaction(
                to: fsTransaction,
                from: from,
                to: to,
                amount: amount,
                date: nextDate,
                approvalMode: approvalMode, recurrenceFrequency: recurrenceFrequency,
                recurrenceEnd: recurrenceEnd,
                parent: parent ?? newFinTransactionRef.documentID,
                result: (approvedAmount, dynamics))
        } else {
            return (approvedAmount, [Date: Int]())
        }
    }
}
