//
//  AppDelegate.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 05/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkForFirstLaunch()
        return true
    }
    
    func checkForFirstLaunch() {
        if UserDefaults.standard.object(forKey: Constants.firstLaunchKey) == nil {
            UserDefaults.standard.set(true, forKey: Constants.firstLaunchKey)
            UserDefaults.standard.set(false, forKey: Constants.darkModeKey)
            UserDefaults.standard.synchronize()
        }
    }

}

