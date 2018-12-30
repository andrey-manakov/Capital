
class FIRManagerProtocol {
    
}

class FIRManager {
    let db = Firestore.firestore()
    var ref: DocumentReference? {
        guard let user = FIRAuth.shared.currentUserUid else {return nil}
        return Firestore.firestore().document("users/\(user)")
    }
    let capitalAccountName = "capital"
    var capitalDoc: DocumentReference? {return ref?.collection(DataObjectType.account.rawValue).document(capitalAccountName)}
}
