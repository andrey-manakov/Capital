/// Protocol to access `SettingsViewController`
internal protocol SettingsViewControllerProtocol: ViewControllerProtocol {
    /// Service class for this view controller, providing functionality of data access
    var service: SettingsServiceProtocol { get set }
    /// Table with settings items
    var table: SimpleTableProtocol { get set } // TODO: consider hiding subview
}

/// ViewController showing app settings
internal final class SettingsViewController: ViewController, SettingsViewControllerProtocol {
    /// Service class for this view controller, providing functionality of data access
    internal var service: SettingsServiceProtocol = SettingsService()
    /// Table with settings items
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
