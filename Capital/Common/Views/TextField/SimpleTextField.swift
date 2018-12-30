
import UIKit

class SimpleTextField: UITextField, TextFieldProtocol, UITextFieldDelegate {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    var actionOnReturn: (()->())?
    
    init(_ placeholder: String? = nil, _ actionOnReturn: (()->())? = nil) {
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
//        becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {return bounds.inset(by: padding)}
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {return bounds.inset(by: padding)}
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {return bounds.inset(by: padding)}
    
    deinit {
        print("deinit \(type(of: self))")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        actionOnReturn?()
        return true
    }
    
}

