internal class SimpleTextField: UITextField, TextFieldProtocol, UITextFieldDelegate {

    private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    internal var actionOnReturn: (() -> Void)?

    internal init(_ placeholder: String? = nil, _ actionOnReturn: (() -> Void)? = nil) {
        super.init(frame: CGRect.zero)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
        self.placeholder = placeholder
        self.actionOnReturn = actionOnReturn
        self.delegate = self
    }

    required internal init?(coder aDecoder: NSCoder) {
        return nil
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    deinit {
        print("deinit \(type(of: self))")
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        actionOnReturn?()
        return true
    }

}
