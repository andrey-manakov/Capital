import UIKit

protocol SimpleLabelProtocol {
    var text: String? {get set}
}

class SimpleLabel: UILabel, SimpleLabelProtocol {
    init(_ text: String? = nil) {
        super.init(frame: CGRect.zero)
        self.text = text
        lineBreakMode = .byWordWrapping
        numberOfLines = 2
    }

    convenience init(_ text: String? = nil, alignment: NSTextAlignment? = nil, lines: Int? = nil) {
        self.init(text)
        if let alignment = alignment {
            self.textAlignment = alignment
        }
        if let lines = lines {
            self.numberOfLines = lines
        }
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}
