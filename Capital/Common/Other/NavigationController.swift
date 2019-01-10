import UIKit

internal class NavigationController: UINavigationController {
    internal convenience init(_ viewController: UIViewController) {
        self.init()
        self.viewControllers.append(viewController)
    }
    deinit { print("\(type(of: self)) deinit!") }
}
