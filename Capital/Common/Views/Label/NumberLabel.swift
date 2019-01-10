internal final class NumberLabel: SimpleLabel {
    override internal init(_ text: String? = nil) {
        super.init(text)
        textAlignment = .right
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

}
