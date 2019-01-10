internal final class EmailField: SimpleTextField {
    override internal init(_ placeholder: String? = nil, _ actionOnReturn: (() -> Void)? = nil) {
        super.init(placeholder, actionOnReturn)
        keyboardType = .emailAddress
    }
    required internal init?(coder aDecoder: NSCoder) {
        return nil
    }
}
