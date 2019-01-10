/// Getters for FireStore Transactions (reads before atomic write)
protocol FireStoreGettersProtocol {
    var ref: DocumentReference? { get }
}

extension FireStoreGettersProtocol {

    func getUserData(for fsTransaction: Transaction,
                     with errorPointer: NSErrorPointer = nil) -> DocumentSnapshot? {
        guard let ref = ref else { return nil }
        let doc: DocumentSnapshot
        do {
            try doc = fsTransaction.getDocument(ref)
        } catch let fetchError as NSError {
            errorPointer?.pointee = fetchError
            return nil
        }
        return doc
    }

    func get(_ dataObject: DataObjectType,
             withId id: String?,
             for fsTransaction: Transaction,
             with errorPointer: NSErrorPointer = nil) -> DataObjectProtocol? {
        guard let ref = ref, let id = id else { return nil }
        let doc: DocumentSnapshot
        do {
            try doc = fsTransaction.getDocument(ref.collection(dataObject.rawValue).document(id))
        } catch let fetchError as NSError {
            errorPointer?.pointee = fetchError
            return nil
        }
        guard let data = doc.data() else { return nil }

        switch dataObject {
        case .account: return Account(data)
        case .transaction: return FinTransaction(data)
        case .group: return Account.Group(data)
        case .change: return nil // TODO: double check
        }
    }

    func getAccountGroup(withId id: String?,
                         for fsTransaction: Transaction,
                         with errorPointer: NSErrorPointer = nil) -> Account.Group? {
        return get(.group, withId: id, for: fsTransaction, with: errorPointer) as? Account.Group
    }

    func getAccount(withId id: String?,
                    for fsTransaction: Transaction,
                    with errorPointer: NSErrorPointer = nil) -> Account? {
        return get(.account, withId: id, for: fsTransaction, with: errorPointer) as? Account
    }

    func getTransaction(withId id: String?,
                        for fsTransaction: Transaction,
                        with errorPointer: NSErrorPointer = nil) -> FinTransaction? {
        return get(.transaction, withId: id, for: fsTransaction, with: errorPointer) as? FinTransaction
    }

    func getAmount(ofAccount id: String?,
                   for fsTransaction: Transaction,
                   with errorPointer: NSErrorPointer = nil) -> Int? {
        return getAccount(withId: id, for: fsTransaction, with: errorPointer)?.amount
    }

}
