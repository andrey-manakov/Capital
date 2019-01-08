import UIKit

class RightNumberField: UITextField, TextFieldProtocol {
    var actionOnReturn: (() -> Void)?

    init(_ placeholder: String? = nil) {
        super.init(frame: CGRect.zero)
        textAlignment = .right
        keyboardType = .numberPad
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
