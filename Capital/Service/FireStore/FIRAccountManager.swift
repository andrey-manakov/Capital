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
    internal let finTransactionManager: FIRFinTransactionManagerProtocolOld =
        FIRFinTransactionManagerOld.shared

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
                [Account.Fields.name.rawValue: name,
                 Account.Fields.amount.rawValue: amount,
                 Account.Fields.type.rawValue: type.rawValue],
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
                Account.Fields.name.rawValue: name,
                Account.Fields.amount.rawValue: amount,
                Account.Fields.type.rawValue: type.rawValue], forDocument: newAccountRef)
            // Create transaction

            let transactionFrom = type.active ? (self.capitalAccountName, self.capitalAccountName) :
                (newAccountRef.documentID, name)
            let transactionTo = type.active ? (newAccountRef.documentID, name) :
                (self.capitalAccountName, self.capitalAccountName)
            _ = self.finTransactionManager.sendFinTransaction(
                to: fsTransaction, from: transactionFrom, to: transactionTo, amount: amount)
            // Update capital account
            fsTransaction.updateData([
                Account.Fields.amount.rawValue:
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

        fireDB.runTransaction({[unowned self] fsTransaction, _ -> Any? in
            let account = self.getAccount(withId: id, for: fsTransaction)
            guard let oldAmount = account?.amount, let type = account?.type,
                let capitalAmount = self.getAccount(
                    withId: self.capitalAccountName,
                    for: fsTransaction)?.amount else { return false }
            let oldName = account?.name ?? ""

            let delta: Int
            if let newAmount = amount {
                delta = newAmount - oldAmount
                switch (delta > 0, type.active) {
                case (true, true), (false, false):
                    _ = self.finTransactionManager.sendFinTransaction(
                        to: fsTransaction,
                        from: (self.capitalAccountName, self.capitalAccountName),
                        to: (id, name ?? oldName), amount: abs(delta))

                case (false, true), (true, false):
                    _ = self.finTransactionManager.sendFinTransaction(
                        to: fsTransaction,
                        from: (id, name ?? oldName),
                        to: (self.capitalAccountName, self.capitalAccountName), amount: abs(delta))
                }
                // Update account amount and name
                fsTransaction.updateData(
                    [Account.Fields.amount.rawValue: newAmount,
                     Account.Fields.name.rawValue: name ?? oldName], forDocument: accountDoc)
                // Update Capital account amount
                fsTransaction.updateData(
                    [Account.Fields.amount.rawValue: capitalAmount + delta], forDocument: capitalDoc)
            } else {
                fsTransaction.updateData(
                    [Account.Fields.name.rawValue: name ?? oldName], forDocument: accountDoc)
            }
            return true
            }, completion: fireStoreCompletion)
    }

}
