import UIKit

/// Parent protocol to all View Controllers protocol
protocol ViewControllerProtocol: class {
    var data: Any? {get set}
    func dismiss(completion: (()->Void)?)
    func dimissNavigationViewController(completion: (()->Void)?)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func push(_ viewController: UIViewController)
    func endEditing(force: Bool)
}

extension ViewControllerProtocol {
    func dismissNavigationViewController() {dimissNavigationViewController(completion: nil)}
    func dismiss() {dismiss(completion: nil)}
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        present(viewControllerToPresent, animated: flag, completion: nil)
    }
    func present(_ viewControllerToPresent: UIViewController) {
        present(viewControllerToPresent, animated: true, completion: nil)
    }

}

/// Class used for all View Controllers with common functionality
class ViewController: UIViewController, ViewControllerProtocol {

    /// Generic input info to the new controller
    var data: Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    convenience init(_ data: Any?) {
        self.init()
        self.data = data
    }

    /// Check that View Controller is deallocated - for debug purposes
    deinit {print("\(type(of: self)) deinit!")}

    func dismiss(completion: (()->Void)? = nil) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: completion)
        }
    }
    func dimissNavigationViewController(completion: (()->Void)? = nil) {
        navigationController?.dismiss(animated: true, completion: completion)
    }
    func push(_ vc: UIViewController) {navigationController?.pushViewController(vc, animated: true)}
    func endEditing(force: Bool) {view.endEditing(force)}
    func alert(_ title: String? = nil, message: String) {
        let alert = UIAlertController(title: title ?? "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")

            }}))
        self.present(alert, animated: true, completion: nil)
    }

}
