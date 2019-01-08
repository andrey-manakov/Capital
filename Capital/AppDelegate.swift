//
//  AppDelegate.swift
//  Capital
//
//  Created by Andrey Manakov on 09/12/2018.
//  Copyright © 2018 Andrey Manakov. All rights reserved.
//

import UIKit
//import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var testing = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
        self.window!.makeKeyAndVisible()
        return true
    }
}
