/// Protocol to access `SettingsViewController`
internal protocol SettingsViewControllerProtocol: ViewControllerProtocol {
    var service: SettingsServiceProtocol { get set }
    var table: SimpleTableProtocol { get set } // TODO: consider hiding subview

}

/// <#Description#>
internal final class SettingsViewController: ViewController, SettingsViewControllerProtocol {
    internal var service: SettingsServiceProtocol = SettingsService()
    internal var table: SimpleTableProtocol = SimpleTable()
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        service.viewDidLoad(self)
        title = "Settings"
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        table.didSelect = {[unowned self] row, index in
            self.service.didSelect(row, at: index)
        }
    }
}
