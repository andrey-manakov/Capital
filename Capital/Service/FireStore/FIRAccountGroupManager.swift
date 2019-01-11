internal protocol FIRAccountGroupManagerProtocol: AnyObject {
    func create(_ name: String?, withAccounts accountIds: [String])
    func delete(id: String, completion: (() -> Void)?)
}

extension FIRAccountGroupManagerProtocol {
    internal func delete(id: String) {
        delete(id: id, completion: nil)
    }
}

extension FIRAccountGroupManager: FireStoreCompletionProtocol, FireStoreGettersProtocol {}

internal final class FIRAccountGroupManager: FIRManager, FIRAccountGroupManagerProtocol {
    /// Singlton
    internal static var shared: FIRAccountGroupManagerProtocol = FIRAccountGroupManager()

    override private init() {}

    private func calcAmountGroupAmount(withAccounts accounts: [Account]) -> Int {
        let positiveAmount: Int = accounts.filter {
            $0.type == AccountType.asset
            }.map {
                $0.amount ?? 0
            }.reduce(0, +)
        let negativeAmount: Int = accounts.filter {
            $0.type == AccountType.liability
            }.map { $0.amount ?? 0 }.reduce(0, +)
        return  positiveAmount - negativeAmount
    }

    private func getAccounts(
        withIds id: [String],
        inTransaction fsTransaction: Transaction,
        withErrorPointer errorPointer: NSErrorPointer
        ) -> [String: Account] {
        return Dictionary(uniqueKeysWithValues:
            id.map {
                (id: $0, (self.getAccount(withId: $0, for: fsTransaction, with: errorPointer))!)
        })
    }

    /// Creates Account Group in FireStore data base, also updates accounts
    ///
    /// - Parameters:
    ///   - name: name of new account group
    ///   - accountIds: array of account ids members of the group
    internal func create(_ name: String?, withAccounts accountIds: [String]) {
        guard let ref = ref, let name = name,
            let newRef = self.ref?.collection(DataObjectType.group.rawValue).document() else {
                return
        }

        fireDB.runTransaction({ fsTransaction, errorPointer -> Any? in
            // get accounts from the group
            let accounts: [String: Account] = self.getAccounts(
                withIds: accountIds,
                inTransaction: fsTransaction,
                withErrorPointer: errorPointer
            )

            let amount: Int = self.calcAmountGroupAmount(withAccounts: Array(accounts.values))
            // write to each account information about its membership in group
            accountIds.forEach { id in
                var newAccountGroup = [newRef.documentID: name]
                if let oldAccountGroup = accounts[id]?.groups {
                    // swiftlint:disable identifier_name
                    newAccountGroup = newAccountGroup.merging(oldAccountGroup) { x, _ -> String in x }
                }
                fsTransaction.updateData(
                    [Account.Fields.groups.rawValue: newAccountGroup as Any],
                    forDocument: ref.collection(DataObjectType.account.rawValue).document(id))
            }
            // create account group
            fsTransaction.setData([
                Account.Group.Fields.name.rawValue: name,
                Account.Group.Fields.amount.rawValue: amount,
                Account.Group.Fields.accounts.rawValue:
                    accounts.mapValues { acc in acc.name }], forDocument: newRef)
            return true
        }, completion: fireStoreCompletion)
    }

    /// Deletes Account Group in FireStore data base, also updates accounts
    ///
    /// - Parameters:
    ///   - id: account group id
    ///   - completion: action on deletion completion
    internal func delete(id: String, completion: (() -> Void)? = nil) {
        guard let ref = ref else {
            return
        }
        fireDB.runTransaction({[unowned self] fsTransaction, errorPointer -> Any? in
            // Get account group data
            guard let group = self.get(.group,
                                       withId: id,
                                       for: fsTransaction,
                                       with: errorPointer) as? Account.Group else { return nil }
            // Get accounts data
            if let uniqueKeysWithValues = group.accounts?.keys.map({
                (id: $0, self.get(.account, withId: $0, for: fsTransaction) as? Account)
            }) {
                let accounts = Dictionary(uniqueKeysWithValues: uniqueKeysWithValues)
                accounts.forEach {
                    if let groups = $0.value?.groups {
                        var newGroups = groups
                        newGroups.removeValue(forKey: id)
                        fsTransaction.updateData(
                            [Account.Fields.groups.rawValue: newGroups],
                            forDocument: ref.collection(DataObjectType.account.rawValue).document($0.key))
                    }
                }
            }

            // Delete account group
            fsTransaction.deleteDocument(ref.collection(DataObjectType.group.rawValue).document(id))
            // Update accounts "groups" frield //FIXME: Update accounts "groups" ddosen't work

//            if let accounts = group.accounts {
//            }
            return true
        }, completion: fireStoreCompletion)
    }
}
