protocol FIRAccountGroupManagerProtocol: class {
    func create(_ name: String?, withAccounts accountIds: [String])
    func delete(id: String, completion: (() -> Void)?)
}

extension FIRAccountGroupManagerProtocol {

    func delete(id: String) {
        delete(id: id, completion: nil)
    }

}

extension FIRAccountGroupManager: FireStoreCompletionProtocol, FireStoreGettersProtocol {}

class FIRAccountGroupManager: FIRManager, FIRAccountGroupManagerProtocol {

    /// Singlton
    static var shared: FIRAccountGroupManagerProtocol = FIRAccountGroupManager()
    private override init() {}

    /// Creates Account Group in FireStore data base, also updates accounts
    ///
    /// - Parameters:
    ///   - name: name of new account group
    ///   - accountIds: array of account ids members of the group
    func create(_ name: String?, withAccounts accountIds: [String]) {
        guard let ref = ref, let name = name,
            let newRef = self.ref?.collection(DataObjectType.group.rawValue).document() else {
                return
        }
        fireDB.runTransaction({ (fsTransaction, errorPointer) -> Any? in
            // get accounts from the group
            let accounts: [String: Account] = Dictionary(uniqueKeysWithValues:
                accountIds.map {
                    (id: $0, (self.getAccount(withId: $0, for: fsTransaction, with: errorPointer))!)
            })
            let amount = accounts.values.filter {
                $0.type == AccountType.asset
                }.map {
                    $0.amount ?? 0
                }.reduce(0, +) - accounts.values.filter {
                    $0.type == AccountType.liability
                    }.map {$0.amount ?? 0}.reduce(0, +)
            // write to each account information about its membership in group
            accountIds.forEach { id in
                var newAccountGroup = [newRef.documentID: name]
                if let oldAccountGroup = accounts[id]?.groups {
                    newAccountGroup = newAccountGroup.merging(
                        // swiftlint:disable identifier_name
                        oldAccountGroup, uniquingKeysWith: { x, _ -> String in x})
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
                    accounts.mapValues { acc in acc.name}], forDocument: newRef)
            return true
        }, completion: fireStoreCompletion)

    }

    /// Deletes Account Group in FireStore data base, also updates accounts
    ///
    /// - Parameters:
    ///   - id: account group id
    ///   - completion: action on deletion completion
    func delete(id: String, completion: (() -> Void)? = nil) {
        guard let ref = ref else {return}
        fireDB.runTransaction({[unowned self] (fsTransaction, errorPointer) -> Any? in
            // Get account group data
            guard let group = self.get(.group,
                                       withId: id,
                                       for: fsTransaction,
                                       with: errorPointer) as? Account.Group else {return nil}
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
