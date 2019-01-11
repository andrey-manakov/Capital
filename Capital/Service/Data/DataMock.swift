internal class DataMock: DataProtocol {
    internal var updateAccountCalled = false

    internal func updateAccount(withId id: String?, name: String?, amount: Int?, completion: (() -> Void)?) {
        updateAccountCalled = true
    }

    internal var deleteAccountCalled = false

    internal func deleteAccount(withId id: String, completion: (() -> Void)?) {
        deleteAccountCalled = true
    }

    internal var deleteAccountGroupCalled = false

    internal func deleteAccountGroup(withId id: String, completion: (() -> Void)?) {
        deleteAccountGroupCalled = true
    }

    internal func delete(_ dataObject: DataObjectType, withId id: String?, completion: (() -> Void)?) {}

    internal var deleteUserCalled = false

    internal func deleteUser(completion: ((Error?) -> Void)?) {
        deleteUserCalled = true
    }

    internal func createAccount(
        _ name: String?,
        ofType type: AccountType?,
        withAmount amount: Int?,
        completion: ((String?) -> Void)?
        ) {
    }

    internal func signOut(_ completion: ((Error?) -> Void)?) {}

    internal func signInUser(
        withEmail email: String,
        password pwd: String,
        completion: ((Error?) -> Void)?
        ) {}

    internal func signUpUser(
        withEmail email: String,
        password pwd: String,
        completion: ((Error?) -> Void)?
        ) {}

    // swiftlint:disable identifier_name function_parameter_count
    internal func createTransaction(
        from: AccountInfo?,
        to: AccountInfo?,
        amount: Int?,
        date: Date?,
        approvalMode: FinTransaction.ApprovalMode?,
        recurrenceFrequency: RecurrenceFrequency?,
        recurrenceEnd: Date?,
        completion: ((String?) -> Void)?
        ) {}

    internal func createAccountGroup(named name: String, withAccounts accounts: [AccountInfo]) {}

    internal func deleteAll(completion: (() -> Void)?) {}

    internal func setListnersToTransactionsOfAccount(
        withId id: String, for objectId: ObjectIdentifier,
        completion: @escaping
        ((([(id: String, account: FinTransaction, changeType: ChangeType)]
        ) -> Void))
        ) {}

    internal func setListnerToAccountGroup(
        for objectId: ObjectIdentifier,
        completion: @escaping
        ((([(id: String, accountGroup: Account.Group, changeType: ChangeType)]) -> Void))
        ) {}

    internal func setListnersToAccountsInGroup(
        withId id: String, for objectId: ObjectIdentifier,
        completion: @escaping
        ((([(id: String, account: Account, changeType: ChangeType)]) -> Void))
        ) {
    }

    internal func setListnerToAccounts(
        for objectId: ObjectIdentifier,
        completion: @escaping
        ((([(id: String, account: Account, changeType: ChangeType)]) -> Void))
        ) {
    }

    internal func removeListners(ofObject objectId: ObjectIdentifier) {
    }
}
