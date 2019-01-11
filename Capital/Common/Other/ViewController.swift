import UIKit

/// Parent protocol to all View Controllers protocol
internal protocol ViewControllerProtocol: AnyObject {
    var data: Any? { get set }

    func dismiss(completion: (() -> Void)?)
    func dimissNavigationViewController(completion: (() -> Void)?)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func push(_ viewController: UIViewController)
    func endEditing(force: Bool)
}

extension ViewControllerProtocol {
    internal func dismissNavigationViewController() {
        dimissNavigationViewController(completion: nil)
    }

    internal func dismiss() {
        dismiss(completion: nil)
    }

    internal func present(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        present(viewControllerToPresent, animated: flag, completion: nil)
    }

    internal func present(_ viewControllerToPresent: UIViewController) {
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}

/// Class used for all View Controllers with common functionality
internal class ViewController: UIViewController, ViewControllerProtocol {
    /// Generic input info to the new controller
    internal var data: Any?

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    internal convenience init(_ data: Any?) {
        self.init()
        self.data = data
    }

    /// Check that View Controller is deallocated - for debug purposes
    deinit { print("\(type(of: self)) deinit!") }

    internal func dismiss(completion: (() -> Void)? = nil) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: completion)
        }
    }

    internal func dimissNavigationViewController(completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: true, completion: completion)
    }

    internal func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    internal func endEditing(force: Bool) {
        view.endEditing(force)
    }

    internal func alert(_ title: String? = nil, message: String) {
        let alert = UIAlertController(title: title ?? "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            switch action.style {
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
