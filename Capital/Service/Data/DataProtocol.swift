
protocol DataProtocol {
    
    func signOut(_ completion: ((Error?)->())?)
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?)->())?)
    func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?)->())?)
    
    func createAccount(_ name: String?, ofType type: AccountType?, withAmount amount: Int?, completion: ((String?)->())?)
    func createTransaction(from: AccountInfo?, to: AccountInfo?, amount: Int?, date: Date?, approvalMode: FinTransaction.ApprovalMode?, recurrenceFrequency: RecurrenceFrequency?, recurrenceEnd: Date?, completion: ((String?)->())?)
    func createAccountGroup(named name: String, withAccounts accounts: [AccountInfo])
    
    func delete(_ dataObject:DataObjectType, withId id: String?, completion: (()->())?)
    func deleteAll(completion: (()->())?)
    func deleteAccount(withId id: String, completion: (()->())?) 
    func deleteAccountGroup(withId id: String, completion: (()->())?)
    func deleteUser(completion: ((Error?)->())?)
    
    func updateAccount(withId id: String?, name: String?, amount: Int?, completion: (()->())?)
    
    func setListnersToTransactionsOfAccount(withId id: String,for objectId: ObjectIdentifier, completion: @escaping ((( [(id: String, account: FinTransaction, changeType: ChangeType)])->() )))
    func setListnerToAccountGroup(for objectId: ObjectIdentifier, completion: @escaping ((( [(id: String, accountGroup: Account.Group, changeType: ChangeType)])->() )))
    func setListnersToAccountsInGroup(withId id: String,for objectId: ObjectIdentifier, completion: @escaping ((( [(id: String, account: Account, changeType: ChangeType)])->() )))
    func setListnerToAccounts(for objectId: ObjectIdentifier, completion: @escaping ((( [(id: String, account: Account, changeType: ChangeType)])->() )))
    func removeListners(ofObject objectId: ObjectIdentifier)
}

extension DataProtocol {
    func delete(_ dataObject:DataObjectType, withId id: String?) {
        delete(dataObject, withId: id, completion: nil)
    }
}

// MARK: - Extension to provide functions with default values
extension DataProtocol {
    
    func createAccount(_ name: String, ofType type: AccountType, withAmount amount: Int?) {createAccount(name, ofType: type, withAmount: amount, completion: nil)}
    
    //TODO: consider adding func createTransaction with defaut values
}
