internal typealias SendFinTransactionResult = (approvedAmount: Int, dynamics: [Date: Int])
internal protocol FIRFinTransactionManagerProtocolOld: AnyObject {
//    func createTransaction(
//        from: AccountInfo?, to: AccountInfo?, amount: Int?, date: Date?,
//        approvalMode: FinTransaction.ApprovalMode?, recurrenceFrequency: RecurrenceFrequency?,
//        recurrenceEnd: Date?, completion: ((String?) -> Void)?
//    )
    func create(_ finTransaction: FinTransaction, completion: ((String?) -> Void)?)
    func send(
        _ finTransaction: FinTransaction,
        to fsTransaction: Transaction,
        result: SendFinTransactionResult) -> SendFinTransactionResult
}

extension FIRFinTransactionManagerProtocolOld {
    internal func send(
        _ finTransaction: FinTransaction,
        to fsTransaction: Transaction) -> SendFinTransactionResult {
        return self.send(finTransaction, to: fsTransaction, result: (0, [Date: Int]()))
    }
}

extension FIRFinTransactionManagerOld: FireStoreCompletionProtocol, FireStoreGettersProtocol {}
extension FIRFinTransactionManagerOld: MiscFunctionsProtocol {}

internal final class FIRFinTransactionManagerOld: FIRManager, FIRFinTransactionManagerProtocolOld {
    /// Singlton
    internal static var shared: FIRFinTransactionManagerProtocolOld = FIRFinTransactionManagerOld()

    override private init() {}

    internal func create(_ finTransaction: FinTransaction, completion: ((String?) -> Void)? = nil
        ) {
        guard let ref = ref, let from = finTransaction.from, let to = finTransaction.to, let amount = finTransaction.amount else {
            return
        }
        func updateBlock(fsTransaction: Transaction, errorPointer: NSErrorPointer) -> Any? {
            // MARK: read account amounts from FireStore
            guard // TODO: refactor to make single query
                let fromAccount = self.getAccount(withId: from.id, for: fsTransaction, with: errorPointer),
                let toAccount = self.getAccount(withId: to.id, for: fsTransaction, with: errorPointer)// ,
                //                let fromAccountDynamics = self.getAccountDynamics(withId: from.id, for: fsTransaction, with: errorPointer),
                //                let toAccountDynamics = self.getAccountDynamics(withId: to.id, for: fsTransaction, with: errorPointer)
                else {
                    return nil
            }
            // TODO: refactor to make single query
            let fromAccountDynamics: AccountDynamics
            let toAccountDynamics: AccountDynamics
            if finTransaction.recurrenceEnd?.isAfter(Date()) ?? false && finTransaction.recurrenceFrequency != .never {
                fromAccountDynamics = self.getAccountDynamics(withId: from.id, for: fsTransaction, with: errorPointer) ?? AccountDynamics()
                toAccountDynamics = self.getAccountDynamics(withId: to.id, for: fsTransaction, with: errorPointer) ?? AccountDynamics()
            } else {
                fromAccountDynamics = AccountDynamics()
                toAccountDynamics = AccountDynamics()
            }
            // create transactions
            let nextFinTransaction = FinTransaction(from: from, to: to, amount: amount, date: finTransaction.date, approvalMode: finTransaction.approvalMode, recurrenceFrequency: finTransaction.recurrenceFrequency, recurrenceEnd: finTransaction.recurrenceEnd)
            let sendTransactionResult: SendFinTransactionResult
            sendTransactionResult = self.send(nextFinTransaction, to: fsTransaction)

            // MARK: update account amounts
            // FIXME: add implementation for min amount & date
            let approvedAmount = sendTransactionResult.approvedAmount
            for (id, account) in [from.id: fromAccount, to.id: toAccount] {
                let coef: Int = ((account.type?.active ?? true) ? 1 : -1) * (id == to.id ? 1 : -1)
                let newAmount = (account.amount ?? 0) + coef * approvedAmount
                let minAmount = 0 // TODO: Add impletmentation
                let minDate = Date() // TODO: Add impletmentation
                fsTransaction.updateData(
                    [
                        Account.fields.amount: newAmount,
                        Account.fields.minAmount: minAmount,
                        Account.fields.minDate: minDate
                    ],
                    forDocument: ref.collection(DataObjectType.account.rawValue).document(id))
            }

            // MARK: udpate dynamics doc
            // TODO: add implementation
            return { print("Transaction created") }
        }

        fireDB.runTransaction(updateBlock(fsTransaction:errorPointer:), completion: fireStoreCompletion)
    }

    internal func send(
        _ finTransaction: FinTransaction,
        to fsTransaction: Transaction,
        result: SendFinTransactionResult = (0, [Date: Int]())) -> SendFinTransactionResult {
        guard
            let newFinTransactionRef = self.ref?.collection(DataObjectType.transaction.rawValue).document(),
            let from = finTransaction.from,
            //            let fromDynamics = self.ref?.collection(DataObjectType.dynamics.rawValue).document(),
            let to = finTransaction.to,
            let amount = finTransaction.amount else { return result }
        let date = finTransaction.date ?? Date()
        // TODO: switch to fields
        fsTransaction.setData(
            [
            FinTransaction.Fields.from.rawValue:
                [FinTransaction.Fields.From.id.rawValue: from.id,
                 FinTransaction.Fields.From.name.rawValue: from.name] as Any,
            FinTransaction.Fields.to.rawValue:
                [FinTransaction.Fields.To.id.rawValue: to.id,
                 FinTransaction.Fields.To.name.rawValue: to.name] as Any,
            FinTransaction.Fields.amount.rawValue: amount as Any,
            FinTransaction.Fields.date.rawValue: Timestamp(date: date),
            FinTransaction.Fields.isApproved.rawValue: date <= Date() ? true : false,
            FinTransaction.Fields.approvalMode.rawValue: finTransaction.approvalMode?.rawValue as Any,
            FinTransaction.Fields.recurrenceFrequency.rawValue:
                finTransaction.recurrenceFrequency == nil ? NSNull() : finTransaction.recurrenceFrequency!.rawValue,
            FinTransaction.Fields.recurrenceEnd.rawValue:
                finTransaction.recurrenceEnd == nil ? NSNull() : Timestamp(date: finTransaction.recurrenceEnd!)
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
        if let recurrenceFrequency = finTransaction.recurrenceFrequency, recurrenceFrequency != .never,
            let nextDate = nextDate(from: date, recurrenceFrequency: recurrenceFrequency),
            let recurrenceEnd = finTransaction.recurrenceEnd, nextDate <= recurrenceEnd {
            let nextFinTransaction = FinTransaction(from: from, to: to, amount: amount, date: date, approvalMode: finTransaction.approvalMode, recurrenceFrequency: recurrenceFrequency, recurrenceEnd: recurrenceEnd, parent: finTransaction.parent ?? newFinTransactionRef.documentID)
            return send(nextFinTransaction, to: fsTransaction, result: (approvedAmount, dynamics))
//            return sendFinTransaction(
//                to: fsTransaction,
//                from: from,
//                to: to,
//                amount: amount,
//                date: nextDate,
//                approvalMode: finTransaction.approvalMode,
//                recurrenceFrequency: recurrenceFrequency,
//                recurrenceEnd: recurrenceEnd,
//                parent: finTransaction.parent ?? newFinTransactionRef.documentID,
//                result: (approvedAmount, dynamics))
        } else {
            return (approvedAmount, [Date: Int]())
        }
    }
}
