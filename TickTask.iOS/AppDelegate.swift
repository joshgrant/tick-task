//
//  AppDelegate.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/15/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

// TeamID: 685257RUQP

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var viewController: ViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        viewController = ViewController()
        viewController.view.backgroundColor = Color.faceFill.color
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
