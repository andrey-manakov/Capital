//
//  CapitalUITests.swift
//  CapitalUITests
//
//  Created by Andrey Manakov on 09/12/2018.
//  Copyright © 2018 Andrey Manakov. All rights reserved.
//
import UIKit
import XCTest

//class CapitalUITests: XCTestCase {
//
//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDown() {
//        Springboard.deleteMyApp()
//        //delete data
//        
//        //delete user
////        print(Auth.auth().currentUser)
//        super.tearDown()
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testSignUp() {
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let app = XCUIApplication()
//        app.textFields["loginTextField"].tap()
//        app.keys["x"].tap()
//        app.keys["@"].tap()
//        app.keys["x"].tap()
//        app.keys["."].tap()
//        app.keys["r"].tap()
//        app.keys["u"].tap()
//        app/*@START_MENU_TOKEN@*/.secureTextFields["passwordTextField"]/*[[".secureTextFields[\"password\"]",".secureTextFields[\"passwordTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.keys["f"].tap()
//        app.keys["r"].tap()
//        app.keys["i"].tap()
//        app.keys["e"].tap()
//        app.keys["n"].tap()
//        app.keys["d"].tap()
//        app/*@START_MENU_TOKEN@*/.buttons["signUpButton"]/*[[".buttons[\"Sign Up\"]",".buttons[\"signUpButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        
////        sleep(10)
//        
////        let dashboardNavigationBar = app.navigationBars["DashBoard"]
////        dashboardNavigationBar.buttons["New"].tap()
////        dashboardNavigationBar.buttons["Done"].tap()
//        
////        let tabBarsQuery = app.tabBars
////        tabBarsQuery.buttons["Accounts"].tap()
////        app.navigationBars["Accounts"].buttons["New"].tap()
////        app/*@START_MENU_TOKEN@*/.textFields["an"]/*[[".textFields[\"new account name\"]",".textFields[\"an\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
////        app.keys["x"].tap()
////
////        let aaTextField = app/*@START_MENU_TOKEN@*/.textFields["aa"]/*[[".textFields[\"initial account amount\"]",".textFields[\"aa\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
////        aaTextField.tap()
////        app.keys["9"].tap()
////        app.navigationBars["New account"].buttons["Done"].tap()
//        
////        let app2 = app
////        app2/*@START_MENU_TOKEN@*/.buttons["liability"]/*[[".segmentedControls[\"sc\"].buttons[\"liability\"]",".buttons[\"liability\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
////        app2/*@START_MENU_TOKEN@*/.buttons["asset"]/*[[".segmentedControls[\"sc\"].buttons[\"asset\"]",".buttons[\"asset\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
////        tabBarsQuery.buttons["DashBoard"].tap()
//        XCTAssert(true)
//        
//        
//    }
//
//    func testLogOut() {
//        
//    }
//    
//}

class Springboard {
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    static let settings = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
    
    /**
     Terminate and delete the app via springboard
     */
    class func deleteMyApp() {
        XCUIApplication().terminate()
        
        // Resolve the query for the springboard rather than launching it
        
        springboard.activate()
        
        // Rotate back to Portrait, just to ensure repeatability here
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait
        // Sleep to let the device finish its rotation animation, if it needed rotating
        sleep(2)
        
        // Force delete the app from the springboard
        
        let icon = springboard.otherElements["Home screen icons"].scrollViews.otherElements.icons["Capital"]

        let iconFrame = icon.frame
        let springboardFrame = springboard.frame
        icon.press(forDuration: 2.5)
        
        // Tap the little "X" button at approximately where it is. The X is not exposed directly
        springboard.coordinate(withNormalizedOffset: CGVector(dx: ((iconFrame.minX + 3) / springboardFrame.maxX), dy:((iconFrame.minY + 3) / springboardFrame.maxY))).tap()
        // Wait some time for the animation end
        Thread.sleep(forTimeInterval: 0.5)
        
        //springboard.alerts.buttons["Delete"].firstMatch.tap()
        springboard.buttons["Delete"].firstMatch.tap()
        
        // Press home once make the icons stop wiggling
        XCUIDevice.shared.press(.home)
        // Press home again to go to the first page of the springboard
        XCUIDevice.shared.press(.home)
        // Wait some time for the animation end
        Thread.sleep(forTimeInterval: 0.5)
        
        // Handle iOS 11 iPad 'duplication' of icons (one nested under "Home screen icons" and the other nested under "Multitasking Dock"
        let settingsIcon = springboard.otherElements["Home screen icons"].scrollViews.otherElements.icons["Settings"]
        if settingsIcon.exists {
            settingsIcon.tap()
            settings.tables.staticTexts["General"].tap()
            settings.tables.staticTexts["Reset"].tap()
            settings.tables.staticTexts["Reset Location & Privacy"].tap()
            // Handle iOS 11 iPad difference in error button text
            if UIDevice.current.userInterfaceIdiom == .pad {
                settings.buttons["Reset"].tap()
            }
            else {
                settings.buttons["Reset Warnings"].tap()
            }
            settings.terminate()
        }
        
    }
    
    
}
