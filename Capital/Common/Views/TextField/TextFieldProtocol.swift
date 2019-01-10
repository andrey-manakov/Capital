protocol TextFieldProtocol: class {
    var text: String? { get set }
    var delegate: UITextFieldDelegate? { get set }
    var isFirstResponder: Bool { get }
    func resignFirstResponder() -> Bool
    func becomeFirstResponder() -> Bool
    var actionOnReturn: (() -> Void)? { get set }
}
