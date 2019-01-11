internal final class EmailField: SimpleTextField {
    override internal init(_ placeholder: String? = nil, _ actionOnReturn: (() -> Void)? = nil) {
        super.init(placeholder, actionOnReturn)
        keyboardType = .emailAddress
    }
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
