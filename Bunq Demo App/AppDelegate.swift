//
//  AppDelegate.swift
//  Bunq Demo App
//
//  Created by Emre on 1.12.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        self.window?.rootViewController = SplashViewController()
        
        return true
    }


}

