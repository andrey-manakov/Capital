internal protocol TextFieldProtocol: AnyObject {
    var text: String? { get set }
    var delegate: UITextFieldDelegate? { get set }
    var isFirstResponder: Bool { get }
    var actionOnReturn: (() -> Void)? { get set }

    func resignFirstResponder() -> Bool
    func becomeFirstResponder() -> Bool
}
