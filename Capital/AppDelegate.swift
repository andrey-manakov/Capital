import UIKit

@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?
    internal var testing: Bool = false

    // swiftlint:disable discouraged_optional_collection
    internal func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        
        FirebaseApp.configure()
        let dataBase = Firestore.firestore()
        let settings = dataBase.settings
        settings.areTimestampsInSnapshotsEnabled = true
        settings.isPersistenceEnabled = false
        dataBase.settings = settings

        if NSClassFromString("XCTest") != nil {
            testing = true
            return true
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = LoginVC()
        if let window: UIWindow = self.window {
            window.makeKeyAndVisible()
            return true
        } else {
            return false
        }
    }
}
