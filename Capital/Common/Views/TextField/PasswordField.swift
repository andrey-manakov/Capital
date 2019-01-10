internal final class PasswordField: SimpleTextField {

    override internal init(_ placeholder: String? = nil, _ actionOnReturn: (() -> Void)? = nil) {
        super.init(placeholder, actionOnReturn)
        isSecureTextEntry = true
        self.actionOnReturn = actionOnReturn
        self.delegate = self
    }

    required internal init?(coder aDecoder: NSCoder) {
        return nil
    }

}
