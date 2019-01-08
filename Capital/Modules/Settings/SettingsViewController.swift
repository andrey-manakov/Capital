import UIKit
//FIXME: Switch to import Swift or Foundation

protocol SettingsViewControllerProtocol: ViewControllerProtocol {
    var service: SettingsServiceProtocol {get set}
    var table: SimpleTableProtocol {get set} //TODO: consider hiding subview

}

class SettingsViewController: ViewController, SettingsViewControllerProtocol {
    var service: SettingsServiceProtocol = SettingsService()
    var table: SimpleTableProtocol = SimpleTable()

    override func viewDidLoad() {
        super.viewDidLoad()
        service.viewDidLoad(self)
        title = "Settings"
        view.add(subView: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        table.didSelect = {[unowned self] row, index in
            self.service.didSelect(row, at: index)}
    }
}
