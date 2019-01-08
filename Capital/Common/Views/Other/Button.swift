import UIKit

protocol ButtonProtocol {

}

class Button: UIButton, ButtonProtocol {
    var action: (() -> Void)?

    init(name: String, action: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        self.action = action
        setTitle(name, for: UIControl.State.normal)
        setTitleColor(.red, for: UIControl.State.normal)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.red.cgColor
        layer.cornerRadius = 15.0
        self.addTarget(self, action: #selector(tapAction), for: UIControl.Event.touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    @objc func tapAction() {
        action?()
    }

}
