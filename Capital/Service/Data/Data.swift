extension Data: MiscFunctionsProtocol {}

/// Data is a singleton for all data operations,
/// it is called only by Services: childs from ClassService, and other Services in Services folder
internal class Data: DataProtocol {
    internal static var shared = Data()
//    : DataProtocol = {
//        if (UIApplication.shared.delegate as! AppDelegate).testing {
//            return DataMock()
//        } else {
//            return Data()
//        }
//    }()

    internal static var sharedForUnitTests = DataMock()

    private let fireStorage: FIRDataProtocol? = FireStoreData.shared
    private let fireAuth: FireAuthProtocol? = FIRAuth.shared
    private let accountGroupManager: FIRAccountGroupManagerProtocol? = FIRAccountGroupManager.shared
    private let finTransactionManager: FIRFinTransactionManagerProtocol? = FIRFinTransactionManager.shared
    private let accountManager: FIRAccountManagerProtocol? = FIRAccountManager.shared
    private let listnersManager: FIRListnersProtocol? = FIRListners.shared

    private let capitalAccountName = "capital"

    private init() {}
}

// MARK: - Set up listners
extension Data {
    internal func setListnerToAccounts(
        for objectId: ObjectIdentifier,
        completion: @escaping ((( [(id: String, account: Account, changeType: ChangeType)]) -> Void))
        ) {
        listnersManager?.setListner(forObject: objectId,
                                    toPath: "/\(DataObjectType.account.rawValue)") { data in
            completion(data.map { ($0.id, Account($0.data), $0.changeType) })
        }
    }

    internal func setListnerToAccountGroup(
        for objectId: ObjectIdentifier,
        completion: @escaping
        ((( [(id: String, accountGroup: AccountGroup, changeType: ChangeType)]) -> Void))
        ) {
        listnersManager?.setListner(
        forObject: objectId, toPath: "/\(DataObjectType.group.rawValue)") { data in
            completion(data.map { ($0.id, AccountGroup($0.data), $0.changeType) })
        }
    }

    internal func setListnersToAccountsInGroup(
        withId id: String, for objectId: ObjectIdentifier,
        completion: @escaping ((( [(id: String, account: Account, changeType: ChangeType)]) -> Void))
        ) {
        listnersManager?.setListner(
        forObject: objectId,
        toPath: "/\(DataObjectType.account.rawValue)",
        whereClause: (
            field: "\(Account.Fields.groups.rawValue).\(id)", .isGreaterThan, value: "")) { data in
            completion(data.map { ($0.id, Account($0.data), $0.changeType) })
        }
    }

    internal func setListnersToTransactionsOfAccount(
        withId id: String, for objectId: ObjectIdentifier,
        completion: @escaping
        ((( [(id: String, account: FinTransaction, changeType: ChangeType)]) -> Void))
        ) {
        let path = "/\(DataObjectType.transaction.rawValue)"

        listnersManager?.setListner(
            forObject: objectId, toPath: path,
            whereClause: (field:
                "\(FinTransaction.Fields.from.rawValue).\(FinTransaction.Fields.From.id.rawValue)",
                .isEqualTo, value: id)) { data in
            completion(data.map { ($0.id, FinTransaction($0.data), $0.changeType) })
        }
        listnersManager?.setListner(
            forObject: objectId, toPath: path,
            whereClause: (field:
                "\(FinTransaction.Fields.to.rawValue).\(FinTransaction.Fields.To.id.rawValue)",
                .isEqualTo, value: id)) { data in
            completion(data.map { ($0.id, FinTransaction($0.data), $0.changeType) })
        }
    }

    internal func removeListners(ofObject objectId: ObjectIdentifier) {
        listnersManager?.removeListners(ofObject: objectId)
    }
}

// typealias whereClause = (field: String, com) //FIXME: where clause typealias

// MARK: - Sign In, Sign Out
extension Data {
    internal func signOut(_ completion: ((Error?) -> Void)? = nil) {
        fireAuth?.signOutUser(completion)
    }

    internal func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?) {
        fireAuth?.signInUser(withEmail: email, password: pwd, completion: completion)
    }

    internal func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?) {
        fireAuth?.createUser(withEmail: email, password: pwd, completion: completion)
    }

    internal func deleteUser(completion: ((Error?) -> Void)?) {
        fireAuth?.deleteUser(completion)
    }
}

// MARK: - Private Data Functions, the only reason to have these functions is
// to concentrate all the requests through these functions
extension Data { // Decide if these functions are needed at all

    /// Deletes data object from FireStore DataBase
    ///
    /// - Parameters:
    ///   - dataObject: collection reference (Accounts, Transactions, etc.)
    ///   - id: id of data object to be deleted
    ///   - completion: function to run after successful deletion
    internal func delete(_ dataObject: DataObjectType, withId id: String?, completion: (() -> Void)? = nil) {
        guard let id = id else {
            return
        }
        switch dataObject {
        case .account:
        break// deleteAccount(withId: id, completion)

        case .group:
            accountGroupManager?.delete(id: id, completion: completion)

        case .transaction:
        break // deleteFinTransaction(withId: id, completion)
        case .change:
            break // TODO: double check
        }
    }

    private func update(
        _ dataObject: DataObjectType,
        id: String,
        with values: [String: Any?], completion: (() -> Void)? = nil
        ) {
        fireStorage?.update(dataObject, id: id, with: values, completion: completion)
    }
}

// MARK: - Public Data functions
extension Data {
    internal func createAccount(
        _ name: String?,
        ofType type: AccountType?,
        withAmount amount: Int?,
        completion: ((String?) -> Void)? = nil
        ) {
        accountManager?.createAccount(name, ofType: type, withAmount: amount, completion: completion)
    }

    internal func createTransaction(
        from: AccountInfo?,
        to: AccountInfo?,
        amount: Int?,
        date: Date? = Date(),
        approvalMode: FinTransaction.ApprovalMode? = nil,
        recurrenceFrequency: RecurrenceFrequency? = nil,
        recurrenceEnd: Date? = nil,
        completion: ((String?) -> Void)? = nil
        ) {
        FIRFinTransactionManagerOld.shared.createTransaction(
            from: from, to: to, amount: amount, date: date, approvalMode: approvalMode,
            recurrenceFrequency: recurrenceFrequency, recurrenceEnd: recurrenceEnd,
            completion: completion)
//        finTransactionManager?.createTransaction(
//            from: from, to: to, amount: amount, date: date, approvalMode: approvalMode,
//            recurrenceFrequency: recurrenceFrequency, recurrenceEnd: recurrenceEnd,
//            completion: completion)
    }

    internal func createAccountGroup(named name: String, withAccounts accounts: [AccountInfo]) {
        accountGroupManager?.create(name, withAccounts: accounts.map { $0.id })
    }

    internal func deleteAccount(withId id: String, completion: (() -> Void)?) {
    }

    internal func deleteAccountGroup(withId id: String, completion: (() -> Void)?) {
        // FIXME: add implementation
    }

    internal func deleteTransaction(withId id: String) {
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

    /// Function is used to update account value without details of the reasons / transactions, etc.
    /// Account update is performed through creation of the transaction with the 'capital' account.
    /// Events: transaction created + account update ->
    /// transactions child added event + accounts child changed event
    ///
    /// - Parameters:
    ///   - id: Account Id (assigned by Firebase)
    ///   - name: New name (nil means no name update)
    ///   - amount: New account amount (nil means no amount update)

    internal func updateAccount(
        withId id: String?,
        name: String?,
        amount: Int?,
        completion: (() -> Void)? = nil
        ) {
        accountManager?.updateAccount(withId: id, name: name, amount: amount, completion: completion)
    }

    internal func deleteAll(completion: (() -> Void)? = nil) {
        fireStorage?.deleteAll(completion)
    }
}
