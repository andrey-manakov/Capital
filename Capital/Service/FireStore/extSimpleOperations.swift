// MARK: - Simple create, update, delete oprations on FireStore DataBase
extension FireStoreData {
    /// Creates data object in FireStore DataBase
    ///
    /// - Parameters:
    ///   - dataObject: collection reference (Accounts, Transactions, etc.)
    ///   - data: data for data object creation
    ///   - completion: function to run after the action performed with new data object id as a parameter
    func create(_ dataObject: DataObjectType, with data: [String: Any?],
                completion: ((String?) -> Void)? = nil) {
        var docRef: DocumentReference?
        docRef = ref?.collection(dataObject.rawValue).addDocument(data: data as [String: Any]) {err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completion?(docRef?.documentID)
            }
        }
    }

    /// Updates the data object without overwriting the whole document
    ///
    /// - Parameters:
    ///   - dataObject: collection reference (Accounts, Transactions, etc.)
    ///   - id: id of the data object to update
    ///   - values: dictionary with fields and new values to update
    ///   - completion: function to run after successful update
    func update(_ dataObject: DataObjectType, id: String?, with values: [String: Any?],
                completion: (() -> Void)? = nil) {
        guard let id = id else {return}
        ref?.collection(dataObject.rawValue).document(id).updateData(values as [AnyHashable: Any]) {err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                completion?()
            }
        }
    }

}
