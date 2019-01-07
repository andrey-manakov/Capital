import UIKit

class NavigationController: UINavigationController {
    convenience init(_ viewController: UIViewController) {
        self.init()
        self.viewControllers.append(viewController)
    }
    deinit {print("\(type(of: self)) deinit!")}
}
