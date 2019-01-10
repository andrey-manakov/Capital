internal final class TitleLabel: UILabel, SimpleLabelProtocol {
    internal init(_ text: String? = nil) {
        super.init(frame: CGRect.zero)
        self.text = text
        font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        textAlignment = .center
    }

    required internal init?(coder aDecoder: NSCoder) {
        return nil
    }
}
