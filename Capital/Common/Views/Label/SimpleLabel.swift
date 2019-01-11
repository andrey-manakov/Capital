internal protocol SimpleLabelProtocol {
    var text: String? { get set }
}

internal class SimpleLabel: UILabel, SimpleLabelProtocol {
    internal init(_ text: String? = nil) {
        super.init(frame: CGRect.zero)
        self.text = text
        lineBreakMode = .byWordWrapping
        numberOfLines = 2
    }

    internal convenience init(_ text: String? = nil, alignment: NSTextAlignment? = nil, lines: Int? = nil) {
        self.init(text)
        if let alignment = alignment {
            self.textAlignment = alignment
        }
        if let lines = lines {
            self.numberOfLines = lines
        }
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
