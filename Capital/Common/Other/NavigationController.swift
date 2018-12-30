
import UIKit

class NavigationController: UINavigationController {
    convenience init(_ vc: UIViewController) {
        self.init()
        self.viewControllers.append(vc)
    }
    deinit {print("\(type(of: self)) deinit!")}
    
}

