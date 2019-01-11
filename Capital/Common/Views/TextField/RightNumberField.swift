internal final class RightNumberField: UITextField, TextFieldProtocol {
    internal var actionOnReturn: (() -> Void)?

    internal init(_ placeholder: String? = nil) {
        super.init(frame: CGRect.zero)
        textAlignment = .right
        keyboardType = .numberPad
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
