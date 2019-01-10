protocol NewAccountServiceProtocol: class {
    internal var view: NewAccountViewControllerProtocol? { get set }

    internal func didTapDoneWith(name: String?, amount: String?, type: Int)
}
