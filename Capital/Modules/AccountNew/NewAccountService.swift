// import Foundation

protocol NewAccountServiceProtocol: class {
    var view: NewAccountViewControllerProtocol? { get set }
    func didTapDoneWith(name: String?, amount: String?, type: Int)
}
