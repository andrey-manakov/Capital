

extension Data: MiscFunctionsProtocol {}

/// Data is a singleton for all data operations, it is called only by Services: childs from ClassService, and other Services in Services folder
class Data: DataProtocol {

    static var shared = Data()
//    : DataProtocol = {
//        if (UIApplication.shared.delegate as! AppDelegate).testing {
//            return DataMock()
//        } else {
//            return Data()
//        }
//    }()
    
    static var sharedForUnitTests = DataMock()
    
    private let fs: FIRDataProtocol? = FireStoreData.shared
    private let fa: FireAuthProtocol? = FIRAuth.shared
    private let accountGroupManager: FIRAccountGroupManagerProtocol? = FIRAccountGroupManager.shared
    private let finTransactionManager: FIRFinTransactionManagerProtocol? = FIRFinTransactionManager.shared
    private let accountManager: FIRAccountManagerProtocol? = FIRAccountManager.shared
    private let listnersManager: FIRListnersProtocol? = FIRListners.shared
    
    let capitalAccountName = "capital"

    private init() {}
    
}

// MARK: - Set up listners
extension Data {

    func setListnerToAccounts(for objectId: ObjectIdentifier, completion: @escaping ((( [(id: String, account: Account, changeType: ChangeType)])->() ))) {
        listnersManager?.setListner(forObject: objectId, toPath: "/\(DataObjectType.account.rawValue)") {data in
            completion(data.map{($0.id, Account($0.data), $0.changeType)})
        }
    }
    
    func setListnerToAccountGroup(for objectId: ObjectIdentifier, completion: @escaping ((( [(id: String, accountGroup: Account.Group, changeType: ChangeType)])->() ))) {
        listnersManager?.setListner(forObject: objectId, toPath: "/\(DataObjectType.group.rawValue)") {data in
            completion(data.map{($0.id, Account.Group($0.data), $0.changeType)})
        }
    }
    
    func setListnersToAccountsInGroup(withId id: String, for objectId: ObjectIdentifier, completion: @escaping ((( [(id: String, account: Account, changeType: ChangeType)])->() ))) {
        listnersManager?.setListner(forObject: objectId, toPath: "/\(DataObjectType.account.rawValue)", whereClause: (field: "\(Account.Fields.groups.rawValue).\(id)", .isGreaterThan ,value: "")) {data in
            completion(data.map{($0.id, Account($0.data), $0.changeType)})
        }
    }
    
    func setListnersToTransactionsOfAccount(withId id: String,for objectId: ObjectIdentifier, completion: @escaping ((( [(id: String, account: FinTransaction, changeType: ChangeType)])->() ))) {
        let path = "/\(DataObjectType.transaction.rawValue)"
        
        listnersManager?.setListner(forObject: objectId, toPath: path, whereClause:
        (field: "\(FinTransaction.Fields.from.rawValue).\(FinTransaction.Fields.From.id.rawValue)", .isEqualTo ,value: id)) {data in
            completion(data.map{($0.id, FinTransaction($0.data), $0.changeType)})
        }
        listnersManager?.setListner(forObject: objectId, toPath: path, whereClause:
        (field: "\(FinTransaction.Fields.to.rawValue).\(FinTransaction.Fields.To.id.rawValue)", .isEqualTo ,value: id)) {data in
            completion(data.map{($0.id, FinTransaction($0.data), $0.changeType)})
        }
    }
    
    func removeListners(ofObject objectId: ObjectIdentifier) {
        listnersManager?.removeListners(ofObject: objectId)
    }
}

//typealias whereClause = (field: String, com) //FIXME: where clause typealias

//MARK: - Sign In, Sign Out
extension Data {
    func signOut(_ completion: ((Error?)->())? = nil) {
        fa?.signOutUser(completion)}
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?)->())?) {
        fa?.signInUser(withEmail: email, password: pwd, completion: completion)
    }
    func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?)->())?) {
        fa?.createUser(withEmail: email, password: pwd, completion: completion)}
    func deleteUser(completion: ((Error?)->())?) {
        fa?.deleteUser(completion)
    }
}

//MARK: - Private Data Functions, the only reason to have these functions is to concentrate all the requests through these functions
extension Data { //Decide if these functions are needed at all
    
    
    /// Deletes data object from FireStore DataBase
    ///
    /// - Parameters:
    ///   - dataObject: collection reference (Accounts, Transactions, etc.)
    ///   - id: id of data object to be deleted
    ///   - completion: function to run after successful deletion
    func delete(_ dataObject: DataObjectType, withId id: String?, completion: (() -> ())? = nil) {
        guard let id = id else {return}
        switch dataObject {
        case .account: break//deleteAccount(withId: id, completion)
        case .group: accountGroupManager?.delete(id: id, completion: completion) //deleteAccountGroup(withId: id, completion)
        case .transaction: break //deleteFinTransaction(withId: id, completion)
        case .change: break // TODO: double check
        }
    }

    
    
    private func update(_ dataObject: DataObjectType, id: String, with values: [String: Any?], completion: (()->())? = nil) {
        fs?.update(dataObject, id: id, with: values, completion: completion)
    }

//    private func update(accountWithId id: String, withAmount amount: Int, andDirection dir: Direction, completion: (()->())? = nil) {
//        guard let account = self.accounts[id],
//            let type = account.type else {return}
//
//        switch (type.active, dir) {
//        case (true, .from), (false, .to):
//            self.update(.account, id: id, with: ["amount": (account.amount ?? 0) - amount]) {completion?()}
//        case (true, .to), (false, .from):
//            self.update(.account, id: id, with: ["amount": (account.amount ?? 0) + amount]) {completion?()}}
//    }

}

//MARK: - Public Data functions
extension Data {
    
    func createAccount(_ name: String?, ofType type: AccountType?, withAmount amount: Int?, completion: ((String?)->())? = nil) {
        accountManager?.createAccount(name, ofType: type, withAmount: amount, completion: completion)
    }
    //TODO: consider remove default value for date
    func createTransaction(from: AccountInfo?, to: AccountInfo?, amount: Int?, date: Date? = Date(), approvalMode: FinTransaction.ApprovalMode? = nil, recurrenceFrequency: RecurrenceFrequency? = nil, recurrenceEnd: Date? = nil, completion: ((String?)->())? = nil) {

        finTransactionManager?.createTransaction(from: from, to: to, amount: amount, date: date, approvalMode: approvalMode, recurrenceFrequency: recurrenceFrequency, recurrenceEnd: recurrenceEnd, completion: completion)

        //FIXME: make selection based on settings
        //FIXME: send name of from and to
        //FIXME: approve in cloud
        //FIXME: set parent and recurrence transactions
//        var date: Date? = date ?? Date()
//        while date != nil && date! <= recurrenceEnd ?? Date() {
//            fs?.create(.transaction, with: [
//                FinTransaction.Fields.amount.rawValue : amount,
//                FinTransaction.Fields.approvalMode.rawValue: approvalMode?.rawValue,
//                FinTransaction.Fields.date.rawValue: date ,
//                FinTransaction.Fields.from.rawValue: [
//                    FinTransaction.Fields.From.id.rawValue: from?.id, FinTransaction.Fields.From.name.rawValue:from?.name],
//                FinTransaction.Fields.to.rawValue: [
//                    FinTransaction.Fields.To.id.rawValue: to?.id, FinTransaction.Fields.To.name.rawValue: to?.name],
//                FinTransaction.Fields.isApproved.rawValue: date ?? Date() <= Date(),
//                FinTransaction.Fields.parent.rawValue: NSNull(),
//                FinTransaction.Fields.recurrenceEnd.rawValue: recurrenceEnd ?? NSNull(),
//                FinTransaction.Fields.recurrenceFrequency.rawValue: recurrenceFrequency?.rawValue ?? NSNull()], completion: completion)
//            date = nextDate(from: date, recurrenceFrequency: recurrenceFrequency)
//        }

        
        
        //        repeat {
//            date = nextDate(from: date, recurrenceFrequency: recurrenceFrequency)
//        } while date! <= recurrenceEnd ?? Date() && recurrenceFrequency != nil && recurrenceFrequency! != .never

//        finTransactionManager?.createTransaction(from: from, to: to, amount: amount, date: date, approvalMode: approvalMode, recurrenceFrequency: recurrenceFrequency, recurrenceEnd: recurrenceEnd, completion: completion)
    }
    
    func createAccountGroup(named name: String, withAccounts accounts: [AccountInfo]) {//FIXME: add completion
        accountGroupManager?.create(name, withAccounts: accounts.map{$0.id}) // TODO: introduce completion
//        fs.createAccountGroup(name, withAccounts: accounts)
    }
    
    func deleteAccount(withId id: String, completion: (() -> ())?) {
        //FIXME: add implementation
//        if (UIApplication.shared.delegate as! AppDelegate).testing {
//            print("deleteAccount during test")
//            deleteAccountWasCalled = true
//        }
        //FIXME: Add implementation
//        var capitalAccountChange = 0
//        delete(.account, withId: id) {}
//
//        for (trId, tr) in transactions.filter({$0.value.from == id || $0.value.to == id}) {
//            if tr.from == id {
//                if tr.to == capitalAccountName {
//                    capitalAccountChange += tr.amount ?? 0
//                    delete(.transaction, withId: trId)}
//                else {update(.transaction, id: trId, with: ["from" : capitalAccountName])}
//            } else {
//                if tr.from == capitalAccountName {
//                    delete(.transaction, withId: trId)
//                    capitalAccountChange -= tr.amount ?? 0}
//                else {update(.transaction, id: trId, with: ["to" : capitalAccountName])}
//            }
//        }
//        update(.account, id: capitalAccountName, with: ["amount" : ((accounts[capitalAccountName]?.amount ?? 0) + capitalAccountChange)])
    }
    
    func deleteAccountGroup(withId id: String, completion: (()->())?) {
        //FIXME: add implementation
    }
    
    func deleteTransaction(withId id: String) {
//        //FIXME: account value is not updated
//        guard let accountFromId = transactions[id]?.from,
//            let accountToId = transactions[id]?.to,
//            let amount = transactions[id]?.amount else {fatalError("could not find transaction or field")}
//        
//        delete(.transaction, withId: id) {
//            self.update(accountWithId: accountFromId, withAmount: amount, andDirection: .to)
//            self.update(accountWithId: accountToId, withAmount: amount, andDirection: .from)
//        }
    }
    
    /// Function is used to update account value without details of the reasons / transactions, etc. Account update is performed through creation of the transaction with the 'capital' account. Events: transaction created + account update -> transactions child added event + accounts child changed event
    ///
    /// - Parameters:
    ///   - id: Account Id (assigned by Firebase)
    ///   - name: New name (nil means no name update)
    ///   - amount: New account amount (nil means no amount update)
    
    func updateAccount(withId id: String?, name: String?, amount: Int?, completion: (()->())? = nil) {
        accountManager?.updateAccount(withId: id, name: name, amount: amount, completion: completion)
    }
    
    func deleteAll(completion: (()->())? = nil) {
        fs?.deleteAll(completion)
    }
    
}
