protocol FireAuthProtocol {
    var currentUserUid: String? {get}
    func deleteUser(_ completion: ((Error?) -> Void)?)
    func signOutUser(_ completion: ((Error?) -> Void)?)
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)
    func createUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)
}

class FIRAuth: FireAuthProtocol {

    static var shared = FIRAuth()
    private lazy var fireStorage: FIRDataProtocol = FireStoreData.shared // TODO: get rid of lazy

    var currentUser: User? {return Auth.auth().currentUser}
    var currentUserUid: String? {return currentUser?.uid}
    lazy var getUpdatedUserInfo = [ObjectIdentifier: (String?)->Void]()

    private init() {
        Auth.auth().addStateDidChangeListener { auth, user in _ =
            self.getUpdatedUserInfo.values.map {$0(Auth.auth().currentUser?.uid)}
            if let user = user {
                let newLog = Firestore.firestore().collection("log").document()
                newLog.setData(["timestamp": FieldValue.serverTimestamp(),
                                "user": user.uid])
            }

        }
    }

    func createUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().createUser(withEmail: email, password: pwd) { _, error in
            if let error = error {
                print("Error in user creation \(error.localizedDescription)")
                completion?(error)
            } else {
                // FIXME: update through fs object
                if let user = Auth.auth().currentUser?.uid {
                    Firestore.firestore().document("users/\(user)").setData(
                    ["email": email, "password": pwd]) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("email and password are saved user record")
                        }
                        self.fireStorage.checkIfCapitalAccountExist { error in
                            if let error = error {
                                print("Error in capital account check or creation")
                                print("\(error.localizedDescription)")
                            }
                            completion?(error)
                        }
                    }
                }
            }
        }
    }

    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().signIn(withEmail: email, password: pwd) { _, error in completion?(error)}
    }

    func signOutUser(_ completion: ((Error?) -> Void)? = nil) {
        do {
            try Auth.auth().signOut()
            completion?(nil)
        } catch let error {
            print("Auth sign out failed: \(error)")
        }
    }

    func deleteUser(_ completion: ((Error?) -> Void)?) {
//        completion?(nil)
        fireStorage.deleteAll {
            if let uid = self.currentUserUid {
                Firestore.firestore().document("users/\(uid)").delete { _ in
                    print("LOG delete user with id \(uid)")
                    // FIXME: change to delete user
                    self.signOutUser { _ in
                        completion?(nil)
                    }
                }
            }
//            self.currentUser?.delete {
//                error in completion?(error)
//                print("result of user delete: \(error?.localizedDescription ?? "SUCCESS")")
//            }
        }
    }

}
