import UIKit

class NumberLabel: SimpleLabel {
    override init(_ text: String? = nil) {
        super.init(text)
        textAlignment = .right
    }

    required init?(coder aDecoder: NSCoder) {return nil}
}
