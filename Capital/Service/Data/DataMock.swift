class DataMock: DataProtocol {
    
    var updateAccountCalled = false
    func updateAccount(withId id: String?, name: String?, amount: Int?, completion: (() -> ())?) {updateAccountCalled = true}
    
    var deleteAccountCalled = false
    func deleteAccount(withId id: String, completion: (()->())?) {deleteAccountCalled = true}

    var deleteAccountGroupCalled = false
    func deleteAccountGroup(withId id: String, completion: (()->())?) {deleteAccountGroupCalled = true}
    
    func delete(_ dataObject: DataObjectType, withId id: String?, completion: (() -> ())?) {}
    var deleteUserCalled = false
    func deleteUser(completion: ((Error?) -> ())?) {deleteUserCalled = true}
    
    func createAccount(_ name: String?, ofType type: AccountType?, withAmount amount: Int?, completion: ((String?) -> ())?) {
        
    }
    
    
    func signOut(_ completion: ((Error?) -> ())?) {}
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> ())?) {}
    func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?) -> ())?) {}
    
    func createTransaction(from: AccountInfo?, to: AccountInfo?, amount: Int?, date: Date?, approvalMode: FinTransaction.ApprovalMode?, recurrenceFrequency: RecurrenceFrequency?, recurrenceEnd: Date?, completion: ((String?) -> ())?) {}
    func createAccountGroup(named name: String, withAccounts accounts: [AccountInfo]) {}
    func deleteAll(completion: (() -> ())?) {}
    func setListnersToTransactionsOfAccount(withId id: String, for objectId: ObjectIdentifier, completion: @escaping ((([(id: String, account: FinTransaction, changeType: ChangeType)]) -> ()))) {}
    func setListnerToAccountGroup(for objectId: ObjectIdentifier, completion: @escaping ((([(id: String, accountGroup: Account.Group, changeType: ChangeType)]) -> ()))) {}
    func setListnersToAccountsInGroup(withId id: String, for objectId: ObjectIdentifier, completion: @escaping ((([(id: String, account: Account, changeType: ChangeType)]) -> ()))) {
    }
    
    func setListnerToAccounts(for objectId: ObjectIdentifier, completion: @escaping ((([(id: String, account: Account, changeType: ChangeType)]) -> ()))) {
        
    }
    
    func removeListners(ofObject objectId: ObjectIdentifier) {
        
    }
    
}
