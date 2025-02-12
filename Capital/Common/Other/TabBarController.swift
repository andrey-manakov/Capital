internal protocol TabBarControllerProtocol {
}

/// Main viewcontroller shown upon successful login
///
/// Calls:
/// * `AccountGroupsViewController`
/// * `AccountListVC`
/// * `AdvancedNewTransactionVC`
/// * `AdvancedNewTransactionVC`
/// * `TransactionListVC`
/// * `SettingsViewController`
///
/// Called by:
/// * `LoginVC`
internal final class TabBarController: UITabBarController, TabBarControllerProtocol {
    internal init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [
            NavigationController(AccountGroupsVC()),
            NavigationController(AccountListVC()),
            NavigationController(AdvancedNewTransactionVC()),
            NavigationController(AccountListVC()),
            NavigationController(SettingsViewController())
        ]

        tabBar.items?[0].image = UIImage(named: "DashBoard")
        tabBar.items?[0].title = "DashBoard"
        tabBar.items?[1].image = UIImage(named: "Accounts")
        tabBar.items?[1].title = "Accounts"
        tabBar.items?[2].image = UIImage(named: "New Transaction")
        tabBar.items?[2].title = "New Transaction"
        tabBar.items?[3].image = UIImage(named: "Transactions")
        tabBar.items?[3].title = "Transactions"
        tabBar.items?[4].image = UIImage(named: "Settings")
        tabBar.items?[4].title = "Settings"
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    deinit { print("\(type(of: self)) deinit!") }

    internal struct TabBarItem {
    }
}
