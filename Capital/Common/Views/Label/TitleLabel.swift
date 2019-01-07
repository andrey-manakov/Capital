import UIKit

class TitleLabel: UILabel, SimpleLabelProtocol {
    init(_ text: String? = nil) {
        super.init(frame: CGRect.zero)
        self.text = text
        font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {return nil}
}
