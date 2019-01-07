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
        if let alignmentV = alignment {self.textAlignment = alignmentV}
        if let linesV = lines {self.numberOfLines = linesV}
    }

    required init?(coder aDecoder: NSCoder) {return nil}
}
