protocol FIRListnersProtocol {
    func setListner(forObject objectId: ObjectIdentifier,
                    toPath path: String,
                    whereClause: (field: String, comparisonType: ComparisonType, value: Any)?,
                    completion: @escaping
        ([(id: String, data: [String: Any], changeType: ChangeType)]) -> Void)
    func removeListners(ofObject objectId: ObjectIdentifier)
}

extension FIRListnersProtocol {

    internal func setListner(
        forObject objectId: ObjectIdentifier,
        toPath path: String,
        completion: @escaping
        ([(id: String, data: [String: Any], changeType: ChangeType)]) -> Void) {
        setListner(forObject: objectId, toPath: path, whereClause: nil, completion: completion)
    }

}

// MARK: - Observers
internal final class FIRListners: FIRManager, FIRListnersProtocol {
    internal typealias WhereClause = (field: String, comparisonType: ComparisonType, value: Any)
    // TODO: Consider moving to the upper level to use in protocols as well
    internal typealias ListnerResult = (id: String, data: [String: Any], changeType: ChangeType)
    /// Singlton
    internal static var shared: FIRListnersProtocol = FIRListners()

    override private init() {
    }

    internal var listners = [ObjectIdentifier: [ListenerRegistration?]]()

    /// Sets listner to FireStore data base
    ///
    /// - Parameters:
    ///   - objectId: id of the object which needs to listen to the changes
    ///   - path: FireStore path
    ///   - whereClause: where clause
    ///   - completion: completion action to process acquired data
    func setListner(
        forObject objectId: ObjectIdentifier,
        toPath path: String, whereClause: WhereClause?,
        completion: @escaping ([ListnerResult]) -> Void) {

        guard let ref = ref else {
            return
        }
        var query: Query = ref.collection(path)
        if let whereClause = whereClause {
            switch whereClause.comparisonType {
            case .isGreaterThan:
                query = query.whereField(whereClause.field, isGreaterThan: whereClause.value)
            case .isGreaterThanOrEqualTo:
                query = query.whereField(whereClause.field, isGreaterThanOrEqualTo: whereClause.value)
            case .isEqualTo:
                query = query.whereField(whereClause.field, isEqualTo: whereClause.value)
            case .arrayContains:
                query = query.whereField(whereClause.field, arrayContains: whereClause.value)
            case .isLessThan:
                query = query.whereField(whereClause.field, isLessThan: whereClause.value)
            case .isLessThanOrEqualTo:
                query = query.whereField(whereClause.field, isLessThanOrEqualTo: whereClause.value)
            }
        }
        let listner = query.addSnapshotListener { snapshot, _ in
            guard let docChanges = snapshot?.documentChanges else {
                return
            }
            completion(
                docChanges.map {
                    (id: $0.document.documentID,
                     data: $0.document.data(),
                     changeType: ChangeType(rawValue: $0.type.rawValue) ?? .modified)
                })
        }

        if listners[objectId] == nil {
            listners[objectId] = [ListenerRegistration?]()
        }
        if var listners = listners[objectId] {
            listners.append(listner)
        }
    }

    /// Removes listners is to be called from deinit of the instance
    ///
    /// - Parameter objectId: id of the instance being deinitialized
    internal func removeListners(ofObject objectId: ObjectIdentifier) {
        guard let objListners = listners[objectId] else {
            return
        }
        for listner in objListners {
            listner?.remove()
        }
        listners.removeValue(forKey: objectId)
    }

}
