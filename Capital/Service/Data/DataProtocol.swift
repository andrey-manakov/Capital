protocol DataProtocol {

    func signOut(_ completion: ((Error?) -> Void)?)
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)
    func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)

    func createAccount(_ name: String?, ofType type: AccountType?, withAmount amount: Int?,
                       completion: ((String?) -> Void)?)
    func createTransaction(from: AccountInfo?, to: AccountInfo?, amount: Int?,
                           date: Date?, approvalMode: FinTransaction.ApprovalMode?,
                           recurrenceFrequency: RecurrenceFrequency?, recurrenceEnd: Date?,
                           completion: ((String?) -> Void)?)
    func createAccountGroup(named name: String, withAccounts accounts: [AccountInfo])

    func delete(_ dataObject: DataObjectType, withId id: String?, completion: (() -> Void)?)
    func deleteAll(completion: (() -> Void)?)
    func deleteAccount(withId id: String, completion: (() -> Void)?)
    func deleteAccountGroup(withId id: String, completion: (() -> Void)?)
    func deleteUser(completion: ((Error?) -> Void)?)

    func updateAccount(withId id: String?, name: String?, amount: Int?, completion: (() -> Void)?)

    func setListnersToTransactionsOfAccount(
        withId id: String, for objectId: ObjectIdentifier,
        completion: @escaping ((( [(id: String, account: FinTransaction, changeType: ChangeType)]) -> Void )))
    func setListnerToAccountGroup(
        for objectId: ObjectIdentifier,
        completion: @escaping
        ((( [(id: String, accountGroup: Account.Group, changeType: ChangeType)]) -> Void )))
    func setListnersToAccountsInGroup(
        withId id: String, for objectId: ObjectIdentifier,
        completion: @escaping ((( [(id: String, account: Account, changeType: ChangeType)]) -> Void )))
    func setListnerToAccounts(
        for objectId: ObjectIdentifier,
        completion: @escaping
        ((( [(id: String, account: Account, changeType: ChangeType)]) -> Void )))
    func removeListners(ofObject objectId: ObjectIdentifier)
}

extension DataProtocol {
    func delete(_ dataObject: DataObjectType, withId id: String?) {
        delete(dataObject, withId: id, completion: nil)
    }
}

// MARK: - Extension to provide functions with default values
extension DataProtocol {

    func createAccount(_ name: String, ofType type: AccountType, withAmount amount: Int?) {
        createAccount(name, ofType: type, withAmount: amount, completion: nil)
    }

    //TODO: consider adding func createTransaction with default values
}
