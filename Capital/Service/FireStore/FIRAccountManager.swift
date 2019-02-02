internal protocol FIRAccountManagerProtocol {
    func createAccount(
        _ name: String?,
        ofType type: AccountType?,
        withAmount amount: Int?,
        completion: ((String?) -> Void)?
    )
    func updateAccount(withId id: String?, name: String?, amount: Int?, completion: (() -> Void)?)
}

extension FIRAccountManager: FireStoreCompletionProtocol, FireStoreGettersProtocol {}

internal final class FIRAccountManager: FIRManager, FIRAccountManagerProtocol {
    internal static var shared: FIRAccountManagerProtocol = FIRAccountManager()

    override private init() {}
    // FIXME: old reference
    internal let finTransactionManager: FIRFinTransactionManagerProtocol =
        FIRFinTransactionManager.shared

    /// Creates transaction in FireStore date base,
    /// creates transaction with capital account to define initial account amount,
    /// and updates capital account
    ///
    /// - Parameters:
    ///   - name: account name
    ///   - type: account type
    ///   - amount: initial monetary account amount
    ///   - completion: action to perform after function finishes execution,
    ///     for now it only works for successes
    internal func createAccount(
        _ name: String?,
        ofType type: AccountType?,
        withAmount amount: Int?,
        completion: ((String?) -> Void)?
        ) {
        guard let ref = ref,
            let name = name,
            let type = type,
            let newAccountRef = self.ref?.collection(DataObjectType.account.rawValue).document() else {
                return
        }
        let amount = amount ?? 0
        if amount == 0 {
            newAccountRef.setData(
                [Account.fields.name: name,
                 Account.fields.amount: amount,
                 Account.fields.typeId: type.rawValue],
                completion: fireStoreCompletion)
            return
        }
        let capitalReference = ref.collection(DataObjectType.account.rawValue).document(capitalAccountName)
        fireDB.runTransaction({[unowned self] fsTransaction, errorPointer -> Any? in
            // Get capital amount
            let capitalAmount = self.getAmount(
                ofAccount: "capital", for: fsTransaction, with: errorPointer) ?? 0
            // Create of the new account
            fsTransaction.setData([
                Account.fields.name: name,
                Account.fields.amount: amount,
                Account.fields.typeId: type.rawValue], forDocument: newAccountRef)
            // Create transaction

            let transactionFrom = type.active ? (self.capitalAccountName, self.capitalAccountName) :
                (newAccountRef.documentID, name)
            let transactionTo = type.active ? (newAccountRef.documentID, name) :
                (self.capitalAccountName, self.capitalAccountName)
            let finTransaction = FinTransaction(from: transactionFrom, to: transactionTo, amount: amount)
            _ = self.finTransactionManager.send(finTransaction, to: fsTransaction)
//            _ = self.finTransactionManager.sendFinTransaction(
//                to: fsTransaction, from: transactionFrom, to: transactionTo, amount: amount)
            // Update capital account
            fsTransaction.updateData([
                Account.fields.amount:
                    type.active ? (capitalAmount + amount) : (capitalAmount - amount)],
                                     forDocument: capitalReference)

            return {
                completion?(newAccountRef.documentID)
                print("Account created: \(newAccountRef.documentID)")
            }
            }, completion: fireStoreCompletion)
    }

    /// Updates account name or / and current value.
    /// Current value is updated by creating transaction with capital account
    ///
    /// - Parameters:
    ///   - id: id of account to be updated
    ///   - name: new account name if needed
    ///   - amount: new account amount if needed
    ///   - completion: action to perform after function finishes execution,
    ///     for now it only works for successes
    internal func updateAccount(
        withId id: String?,
        name: String?,
        amount: Int?,
        completion: (() -> Void)? = nil
        ) {
        guard let id = id,
            let accountDoc = ref?.collection(DataObjectType.account.rawValue).document(id),
            let capitalDoc = capitalDoc else { return }

        func updateBlock(fsTransaction: Transaction, errorPointer: NSErrorPointer) -> Any? {
            guard
                let account = self.getAccount(withId: id, for: fsTransaction),
                let oldAmount = account.amount,
                let type = account.type,
                let capitalAccount = self.getAccount(withId: self.capitalAccountName, for: fsTransaction),
                let capitalAmount = capitalAccount.amount else { return false }

            let oldName: String = account.name ?? ""
            let delta: Int
            if let newAmount = amount {
                delta = newAmount - oldAmount
                let finTransaction: FinTransaction
                switch (delta > 0, type.active) {
                case (true, true), (false, false):
                    finTransaction = FinTransaction(from: (self.capitalAccountName, self.capitalAccountName), to: (id, name ?? oldName), amount: abs(delta))

                case (false, true), (true, false):
                    finTransaction = FinTransaction(from: (id, name ?? oldName), to: (self.capitalAccountName, self.capitalAccountName), amount: abs(delta))
                }
                _ = self.finTransactionManager.send(finTransaction, to: fsTransaction)
                // Update account amount and name
                fsTransaction.updateData(
                    [Account.fields.amount: newAmount,
                     Account.fields.name: name ?? oldName], forDocument: accountDoc)
                // Update Capital account amount
                fsTransaction.updateData(
                    [Account.fields.amount: capitalAmount + delta], forDocument: capitalDoc)
            } else {
                fsTransaction.updateData(
                    [Account.fields.name: name ?? oldName], forDocument: accountDoc)
            }
            return true
        }
        fireDB.runTransaction(updateBlock(fsTransaction:errorPointer:), completion: fireStoreCompletion)
    }
}
