class PasswordField: SimpleTextField {

    override init(_ placeholder: String? = nil, _ actionOnReturn: (() -> Void)? = nil) {
        super.init(placeholder, actionOnReturn)
        isSecureTextEntry = true
        self.actionOnReturn = actionOnReturn
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}
