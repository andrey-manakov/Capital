internal class AppTitle: UILabel {
    internal init() {
        super.init(frame: CGRect.zero)
        text = "CAPITAL"
        font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        textAlignment = .center
    }

    required internal init?(coder aDecoder: NSCoder) {
        return nil
    }
}
