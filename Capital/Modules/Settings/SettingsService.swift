/// Service class for `SettingsVC`
internal protocol SettingsServiceProtocol: AnyObject {
    var view: SettingsViewControllerProtocol? { get set }

    func viewDidLoad(_ view: SettingsViewControllerProtocol)
    func didSelect(_ row: DataModelRowProtocol, at indexPath: IndexPath)
}

// TODO: Consider moving inside Settings View Controller
internal final class SettingsService: ClassService, SettingsServiceProtocol {
    /// Refernce to master view controller
    internal weak var view: SettingsViewControllerProtocol?
    /// Actions to be performed after view controller loaded its view
    internal func viewDidLoad(_ view: SettingsViewControllerProtocol) {
        self.view = view
        getData()
    }
    /// Prepares data for the table
    internal func getData() {
        let rows = Settings.allCases.map {
            DataModelRow(texts: [.id: "\($0.rawValue)", .name: $0.name])
        }
        view?.table.localData = DataModel(rows)
    }
    /// Performs action when certain row in table selected
    ///
    /// Parameters:
    /// - _: row selected
    /// - at: index path of selected row
    internal func didSelect(_ row: DataModelRowProtocol, at indexPath: IndexPath) {
        guard let id = row.texts[.id], let idInt = Int(id), let settings = Settings(rawValue: idInt) else {
            return
        }
        switch settings {
        case .logOut:
            data.signOut { error in
                if let error = error {
                    print("Error in loggin out user \(error.localizedDescription)")
                } else {
                    self.view?.dismissNavigationViewController()
                }
            }

        case .deleteUser:
            data.deleteUser { error in
                if let error = error {
                    print("Error in deleting user \(error.localizedDescription)")
                } else {
                    self.view?.dismissNavigationViewController()
                }
            }
        }
    }
    /// Enum sets available options for settings menu
    /// - logOut: log out user
    /// - deleteUser: delete user from online database
    internal enum Settings: Int, CaseIterable {
        /// Log out user
        case logOut
        /// Delete user from online database
        case deleteUser
        /// Names of the settings items to show in user interface
        internal var name: String {
            switch self {
            case .logOut:
                return "Log Out"
            case .deleteUser:
                return "Delete User"
            }
        }
    }
}
