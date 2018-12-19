
protocol LoginViewControllerProtocol: ViewControllerProtocol {
}

class LoginVC: ViewController, LoginViewControllerProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let service = Service()
        let loginTextField: TextFieldProtocol = EmailField("email")
        let passwordTextField: TextFieldProtocol = PasswordField("password")

        service.listenToAuthUpdates {[unowned self] user in if user != nil {self.present(TabBarController(), animated: true)} else {print("User is nil")}}

        let signInButton: ButtonProtocol = Button(name: "Sign In") {
            service.didTapSignIn(withLogin: loginTextField.text, andPassword: passwordTextField.text) {error in
                if let error = error {self.alert(message: error.localizedDescription)} else {
                    loginTextField.text = ""
                    passwordTextField.text = ""
                }
            }
        }

        let signUpButton: ButtonProtocol = Button(name: "Sign Up") {
            service.didTapSignUp(withLogin: loginTextField.text, andPassword: passwordTextField.text) {error in
                if let error = error {self.alert(message: error.localizedDescription)} else {
                    loginTextField.text = ""
                    passwordTextField.text = ""
                }
            }
        }
        view.add(subViews:
            ["appTitle": AppTitle(),
             "loginTextField" : loginTextField as? UIView,
             "passwordTextField": passwordTextField as? UIView,
             "signInButton": signInButton as? UIView,
             "signUpButton": signUpButton as? UIView], withConstraints:
            ["H:|-50-[appTitle]-50-|",
             "H:|-50-[loginTextField]-50-|",
             "H:|-50-[passwordTextField]-50-|",
             "H:|-100-[signInButton]-100-|",
             "H:|-100-[signUpButton]-100-|",
             "V:|-40-[appTitle(100)]-20-[loginTextField(44)]-20-[passwordTextField(44)]-30-[signInButton(44)]-20-[signUpButton(44)]"])
//        loginTextField.text = "a@a.ru"
//        passwordTextField.text = "friend"
        _ = loginTextField.becomeFirstResponder()
    }
}

extension LoginVC {
    
    private class Service: ClassService {
        
        func listenToAuthUpdates(withAction action: ((String?)->())?) {
            //TODO: don't call Firebase directly
            FIRAuth.shared.getUpdatedUserInfo[ObjectIdentifier(self)] = action
        }
        
        func didTapSignIn(withLogin login: String?, andPassword password: String?, completion: ((Error?)->())? = nil) {
            guard let lgn = login, let pwd = password else {return}
            Data.shared.signInUser(withEmail: lgn, password: pwd, completion: completion)
        }
        
        func didTapSignUp(withLogin login: String?, andPassword password: String?, completion: ((Error?)->())? = nil) {
            guard let lgn = login, let pwd = password else {return} //TODO: consider use UIAlertVC
            Data.shared.signUpUser(withEmail: lgn, password: pwd, completion: completion)
        }
        
    }
}

