class DataMock: DataProtocol {

    var updateAccountCalled = false
    func updateAccount(withId id: String?, name: String?, amount: Int?, completion: (() -> Void)?) {
        updateAccountCalled = true
    }

    var deleteAccountCalled = false
    func deleteAccount(withId id: String, completion: (() -> Void)?) {deleteAccountCalled = true}

    var deleteAccountGroupCalled = false
    func deleteAccountGroup(withId id: String, completion: (() -> Void)?) {deleteAccountGroupCalled = true}

    func delete(_ dataObject: DataObjectType, withId id: String?, completion: (() -> Void)?) {}
    var deleteUserCalled = false
    func deleteUser(completion: ((Error?) -> Void)?) {deleteUserCalled = true}

    func createAccount(_ name: String?, ofType type: AccountType?, withAmount amount: Int?,
                       completion: ((String?) -> Void)?) {

    }

    func signOut(_ completion: ((Error?) -> Void)?) {}
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?) {}
    func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?) {}

    // swiftlint:disable identifier_name function_parameter_count
    func createTransaction(from: AccountInfo?, to: AccountInfo?, amount: Int?, date: Date?,
                           approvalMode: FinTransaction.ApprovalMode?,
                           recurrenceFrequency: RecurrenceFrequency?,
                           recurrenceEnd: Date?, completion: ((String?) -> Void)?) {}
    func createAccountGroup(named name: String, withAccounts accounts: [AccountInfo]) {}
    func deleteAll(completion: (() -> Void)?) {}
    func setListnersToTransactionsOfAccount(
        withId id: String, for objectId: ObjectIdentifier,
        completion: @escaping
        ((([(id: String, account: FinTransaction, changeType: ChangeType)]) -> Void))) {}
    func setListnerToAccountGroup(
        for objectId: ObjectIdentifier,
        completion: @escaping
        ((([(id: String, accountGroup: Account.Group, changeType: ChangeType)]) -> Void))) {}
    func setListnersToAccountsInGroup(
        withId id: String, for objectId: ObjectIdentifier,
        completion: @escaping
        ((([(id: String, account: Account, changeType: ChangeType)]) -> Void))) {
    }

    func setListnerToAccounts(
        for objectId: ObjectIdentifier,
        completion: @escaping
        ((([(id: String, account: Account, changeType: ChangeType)]) -> Void))) {

    }

    func removeListners(ofObject objectId: ObjectIdentifier) {

    }

}
