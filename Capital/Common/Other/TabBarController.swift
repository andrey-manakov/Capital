
protocol TabBarControllerProtocol {
    
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
class TabBarController: UITabBarController, TabBarControllerProtocol {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [NavigationController(AccountGroupsViewController()),
                           NavigationController(AccountListVC()),
                           NavigationController(AdvancedNewTransactionVC()),
                           TestViewController(),
                           NavigationController(SettingsViewController())]

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
    
    required init?(coder aDecoder: NSCoder) {return nil}
    deinit {print("\(type(of: self)) deinit!")}
    
    struct TabBarItem {
        
    }
}

/// Test desc
class TestViewController: UIViewController {
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        print("init of TestViewController done")
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
