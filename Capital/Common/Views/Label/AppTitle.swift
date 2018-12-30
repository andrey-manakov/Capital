

class AppTitle: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        text = "CAPITAL"
        font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        return nil
    }
}


