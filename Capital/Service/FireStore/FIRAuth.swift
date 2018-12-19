
protocol FireAuthProtocol {
    var currentUserUid: String? {get}
    func deleteUser(_ completion: ((Error?)->())?)
    func signOutUser(_ completion: ((Error?)->())?)
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?)->())?)
    func createUser(withEmail email: String, password pwd: String, completion: ((Error?)->())?)
}

class FIRAuth: FireAuthProtocol {
    
    static var shared = FIRAuth()
    private lazy var fs: FIRDataProtocol = FireStoreData.shared //TODO: get rid of lazy
    
    var currentUser: User? {return Auth.auth().currentUser}
    var currentUserUid: String? {return currentUser?.uid}
    lazy var getUpdatedUserInfo = [ObjectIdentifier: (String?)->()]()

    private init() {
        Auth.auth().addStateDidChangeListener() {auth, user in _ =
            self.getUpdatedUserInfo.values.map{$0(Auth.auth().currentUser?.uid)}
            if let user = user {
                let newLog = Firestore.firestore().collection("log").document()
                newLog.setData(["timestamp" : FieldValue.serverTimestamp(),
                                "user" : user.uid])
            }
            
        }
    }

    func createUser(withEmail email: String, password pwd: String, completion: ((Error?)->())? = nil) {
        Auth.auth().createUser(withEmail: email, password: pwd) {authDataResult, error in
            if let error = error {
                print("Error in user creation \(error.localizedDescription)")
            } else {
                self.fs.checkIfCapitalAccountExist()
            }
            if let id = authDataResult?.user.uid  {
                let userDoc = Firestore.firestore().document("users/\(id)")
                userDoc.setData(["email" : email, "password": pwd]) {error in
                    if let error = error {
                        print("LOG Error in setting user data \(error.localizedDescription)")
                    }
                }
            }            
            completion?(error)
        }
    }
    
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?)->())? = nil) {
        Auth.auth().signIn(withEmail: email, password: pwd) {user, error in completion?(error)}
    }

    func signOutUser(_ completion: ((Error?)->())? = nil) {
        do {
            try Auth.auth().signOut()
            completion?(nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
    
    func deleteUser(_ completion: ((Error?) -> ())?) {
        let uid = currentUserUid! // FIXME: !
        Firestore.firestore().document("users/\(uid)").delete() {error in
            print("LOG delete user with id \(uid)")
            self.currentUser?.delete { error in completion?(error)}
        }
    }
}
