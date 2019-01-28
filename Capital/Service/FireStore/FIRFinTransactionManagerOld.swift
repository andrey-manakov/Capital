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
                let toAccount = self.getAccount(withId: to.id, for: fsTransaction, with: errorPointer) else {
                    return nil
            }
            // TODO: refactor to make single query
            let fromAccountDynamics: AccountDynamics
            let toAccountDynamics: AccountDynamics
            if finTransaction.recurrenceEnd?.isAfter(Date()) ?? false && finTransaction.recurrenceFrequency != .never {
                fromAccountDynamics = self.getAccountDynamics(withId: from.id, for: fsTransaction, with: errorPointer) ?? AccountDynamics()
                toAccountDynamics = self.getAccountDynamics(withId: to.id, for: fsTransaction, with: errorPointer) ?? AccountDynamics()
            } else {
                fromAccountDynamics = AccountDynamics() // FIXME: change to running sum?
                toAccountDynamics = AccountDynamics() // FIXME: change to running sum?
            }
            let fromAccountDynamicsRunningSum = fromAccountDynamics.data.values.reduce(into: []) { $0.append(($0.last ?? 0) + $1) }
            let toAccountDynamicsRunningSum = toAccountDynamics.data.values.reduce(into: []) { $0.append(($0.last ?? 0) + $1) }

            // create transactions
            let nextFinTransaction = FinTransaction(from: from, to: to, amount: amount, date: finTransaction.date, approvalMode: finTransaction.approvalMode, recurrenceFrequency: finTransaction.recurrenceFrequency, recurrenceEnd: finTransaction.recurrenceEnd)
            let sendTransactionResult: SendFinTransactionResult
            sendTransactionResult = self.send(nextFinTransaction, to: fsTransaction)

            // MARK: update account amounts
            // FIXME: add implementation for min amount & date
            let approvedAmount = sendTransactionResult.approvedAmount
            for (id, (account, dynamics)) in [from.id: (fromAccount, fromAccountDynamics), to.id: (toAccount, toAccountDynamics )] {
                let coef: Int = ((account.type?.active ?? true) ? 1 : -1) * (id == to.id ? 1 : -1)
                let newAmount = (account.amount ?? 0) + coef * approvedAmount
                var minAmount = newAmount //= 0 // TODO: Add impletmentation
                let minDate = Date() // = Date() // TODO: Add impletmentation

                var runningDynamics = [String: Int]()
                var runningSum = minAmount
                for (dateStr, amount) in dynamics.data {
                    runningSum += amount
                    runningDynamics[dateStr] = runningSum
                }

                for (dateStr, amount) in runningDynamics {
                    minAmount = min(minAmount, minAmount + amount)
                }
                let fields = Account.fields
                let newAccountData: [String : Any] = [fields.amount: newAmount, fields.minAmount: minAmount, fields.minDate: minDate]
                let newAccountRef = ref.collection(DataObjectType.account.rawValue).document(id)
                fsTransaction.updateData(newAccountData, forDocument: newAccountRef)
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
        let fields = FinTransaction.fields
        var newFinTransactionData =
            [
                fields.from: [fields.accountId: from.id, fields.accountName: from.name] as Any,
                fields.to: [fields.accountId: to.id, fields.accountName: to.name] as Any,
                fields.amount: amount as Any,
                fields.date: Timestamp(date: date),
                fields.isApproved: date <= Date() ? true : false,
                fields.approvalMode: finTransaction.approvalMode?.rawValue as Any
            ]
        // FIXME: set condition to recurrence
        if finTransaction.isRecurrent {
            newFinTransactionData[fields.recurrenceFrequency] = finTransaction.recurrenceFrequency?.rawValue ?? NSNull()
            newFinTransactionData[fields.recurrenceEnd] = Timestamp(date: finTransaction.recurrenceEnd!)
        }
        fsTransaction.setData(newFinTransactionData, forDocument: newFinTransactionRef)
//        fsTransaction.setData(
//            [
//                fields.from: [fields.accountId: from.id, fields.accountName: from.name] as Any,
//                fields.to: [fields.accountId: to.id, fields.accountName: to.name] as Any,
//                fields.amount: amount as Any,
//                fields.date: Timestamp(date: date),
//                fields.isApproved: date <= Date() ? true : false,
//                fields.approvalMode: finTransaction.approvalMode?.rawValue as Any,
//                fields.recurrenceFrequency: finTransaction.recurrenceFrequency?.rawValue ?? NSNull(),
//                fields.recurrenceEnd:
//                    finTransaction.recurrenceEnd == nil ? NSNull() : Timestamp(date: finTransaction.recurrenceEnd!)
//            ], forDocument: newFinTransactionRef)
        let approvedAmount: Int
        var dynamics: [Date: Int] = result.dynamics
        if date <= Date() {
            approvedAmount = result.approvedAmount + amount
        } else {
            approvedAmount = result.approvedAmount
            dynamics[date] = (dynamics[date] ?? 0) + amount
        }
        if let recurrenceFrequency = finTransaction.recurrenceFrequency, recurrenceFrequency != .never,
            let nextDate = nextDate(from: date, recurrenceFrequency: recurrenceFrequency),
            let recurrenceEnd = finTransaction.recurrenceEnd, nextDate <= recurrenceEnd {
            let nextFinTransaction = FinTransaction(from: from, to: to, amount: amount, date: date, approvalMode: finTransaction.approvalMode, recurrenceFrequency: recurrenceFrequency, recurrenceEnd: recurrenceEnd, parent: finTransaction.parent ?? newFinTransactionRef.documentID)
            return send(nextFinTransaction, to: fsTransaction, result: (approvedAmount, dynamics))
        } else {
            return (approvedAmount, [Date: Int]())
        }
    }
}
