protocol FireAuthProtocol {
    var currentUserUid: String? {get}
    func signOutUser(_ completion: ((Error?) -> Void)?)
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)
    func createUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)
}

class FIRAuth: FireAuthProtocol {

    static var shared = FIRAuth()

    var currentUser: User? {return Auth.auth().currentUser}
    var currentUserUid: String? {return currentUser?.uid}
    lazy var getUpdatedUserInfo = [ObjectIdentifier: (String?)->Void]()
//    private let fs = FireStoreData.shared

    private init() {
        Auth.auth().addStateDidChangeListener { auth, user in _ =
            self.getUpdatedUserInfo.values.map {$0(Auth.auth().currentUser?.uid)}
            if let user = user {
                let newLog = Firestore.firestore().collection("users/\(user.uid)/log").document()
                newLog.setData(["timestamp": FieldValue.serverTimestamp()]) { error in
                    if let error = error {
                        print(error)
                    }
                }
            }

        }
        if Auth.auth().currentUser != nil {
            //            FIXME: checkAndSetupCapitalAccount(){Data.shared.cleanCoreDataAndSetUpObservers()}
        }
    }

    func createUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().createUser(withEmail: email, password: pwd) {[unowned self] _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            self.signInUser(withEmail: email, password: pwd)
        }
    }

    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().signIn(withEmail: email, password: pwd) { _, error in completion?(error)
            // TODO: consider checking for capital account
        }
    }

    func signOutUser(_ completion: ((Error?) -> Void)? = nil) {
        // TODO: check if removal of observers is needed
        do {
            try Auth.auth().signOut()
            completion?(nil)
        } catch let error {
            print("Auth sign out failed: \(error)")
        }
    }

}
