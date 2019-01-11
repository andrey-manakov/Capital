internal protocol NewAccountServiceProtocol: AnyObject {
    internal var view: NewAccountViewControllerProtocol? { get set }

    internal func didTapDoneWith(name: String?, amount: String?, type: Int)
}
