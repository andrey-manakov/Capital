internal final class NumberField: SimpleTextField {
    override internal init(_ placeholder: String? = nil, _ actionOnReturn: (() -> Void)? = nil) {
        super.init(placeholder, actionOnReturn)
        keyboardType = .numberPad
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
