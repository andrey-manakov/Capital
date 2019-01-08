// MARK: - Capital Account Creation if needed
extension FireStoreData {

    /// Creates Capital account if doesn't exist
    func checkIfCapitalAccountExist(completion: ((Error?) -> Void)? = nil) {
        // FIXME: get rid of text in quotes
        // FIXME: move to sign in sign up
        let capitalRef = ref?.collection(DataObjectType.account.rawValue).document("capital")
        capitalRef?.getDocument { (doc, error) in
            if let error = error {
                completion?(error)
            }
            if let doc = doc, doc.exists {
                print("Capital account exists")
                completion?(error)
            } else {
                print("Capital account creation")
                capitalRef?.setData(["name": "capital", "amount": 0, "type": 4]) { error in
                    completion?(error)
                }
            }
        }
    }

    // FIXME: Change implementation
    func deleteAll(_ completion: (() -> Void)? = nil) {
        // FIXME: decide if delete all accounts should create capital account

        let group = DispatchGroup()

        if let uid = Auth.auth().currentUser?.uid {
            Firestore.firestore().document("users/\(uid)").delete { error in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
            }
        }

        group.enter()
        deleteAll(DataObjectType.account) {
            group.leave()
        }
        group.enter()
        deleteAll(DataObjectType.transaction) {
            group.leave()
        }
        group.enter()
        deleteAll(DataObjectType.group) {
            group.leave()
        }

        group.enter()
        deleteAll(DataObjectType.change) {
            group.leave()
        }

        group.notify(queue: .main) {
            completion?()
        }

    }

    private func deleteAll(_ dataObject: DataObjectType, _ completion: (() -> Void)? = nil) {
        self.ref?.collection(dataObject.rawValue).getDocuments { snapshot, error in
            print(dataObject)
            if let error = error {
                print(error.localizedDescription)
                completion?()
            }
            guard let snapshot = snapshot, snapshot.documents.count > 0 else {
                print("\(dataObject) with 0 records")
                completion?()
                return
            }
            let batch = self.fireDB.batch()
            for doc in snapshot.documents {
                batch.deleteDocument(doc.reference)
            }

            // Commit the batch
            batch.commit { err in
                completion?()
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                }
            }
        }
    }

}
