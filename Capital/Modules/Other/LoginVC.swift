protocol LoginViewControllerProtocol: ViewControllerProtocol {
}

class LoginVC: ViewController, LoginViewControllerProtocol {
    private let service = Service()
    let loginTextField: TextFieldProtocol = EmailField("email")
    let passwordTextField: TextFieldProtocol = PasswordField("password")

    override func viewDidLoad() {
        super.viewDidLoad()
        setListners()
        let signInButton: ButtonProtocol = Button(name: "Sign In", action: signIn)
        let signUpButton: ButtonProtocol = Button(name: "Sign Up", action: signUp)
        // swiftlint:disable line_length
        view.add(subViews:
            ["appTitle": AppTitle(),
             "loginTextField": loginTextField as? UIView,
             "passwordTextField": passwordTextField as? UIView,
             "signInButton": signInButton as? UIView,
             "signUpButton": signUpButton as? UIView], withConstraints:
            ["H:|-50-[appTitle]-50-|",
             "H:|-50-[loginTextField]-50-|",
             "H:|-50-[passwordTextField]-50-|",
             "H:|-100-[signInButton]-100-|",
             "H:|-100-[signUpButton]-100-|",
             "V:|-40-[appTitle(100)]-20-[loginTextField(44)]-20-[passwordTextField(44)]-30-[signInButton(44)]-20-[signUpButton(44)]"])
        _ = loginTextField.becomeFirstResponder()
    }

    private func signIn() {
        guard let login = self.loginTextField.text, let password = self.passwordTextField.text else {return}
        cleanTextFields()
        self.service.didTapSignIn(withLogin: login, andPassword: password) { error in
            if let error = error {
                self.alert(message: error.localizedDescription)
            }
        }
    }

    private func signUp() {
        guard let login = self.loginTextField.text, let password = self.passwordTextField.text else {return}
        cleanTextFields()
        self.service.didTapSignUp(
            withLogin: login,
            andPassword: password) { error in
                if let error = error {
                    self.alert(message: error.localizedDescription)
                }
        }
    }

    private func setListners() {
        service.listenToAuthUpdates {[unowned self] user in
            if user != nil {
                self.present(TabBarController(), animated: true)
            } else {
                print("User is nil")
            }
        }
    }

    private func cleanTextFields() {
        self.loginTextField.text = ""
        self.passwordTextField.text = ""
    }

}

extension LoginVC {

    private class Service: ClassService {

        func listenToAuthUpdates(withAction action: ((String?) -> Void)?) {
            // TODO: don't call Firebase directly
            FIRAuth.shared.getUpdatedUserInfo[ObjectIdentifier(self)] = action
        }

        func didTapSignIn(withLogin login: String?, andPassword password: String?,
                          completion: ((Error?) -> Void)? = nil) {
            guard let lgn = login, let pwd = password else {return}
            Data.shared.signInUser(withEmail: lgn, password: pwd, completion: completion)
        }

        func didTapSignUp(withLogin login: String?, andPassword password: String?,
                          completion: ((Error?) -> Void)? = nil) {
            guard let lgn = login, let pwd = password else {return} // TODO: consider use UIAlertVC
            Data.shared.signUpUser(withEmail: lgn, password: pwd, completion: completion)
        }

    }
}
