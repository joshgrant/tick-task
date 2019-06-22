//
//  AppDelegate.swift
//  TickTask
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa
import ServiceManagement
import CloudKit
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate
{
    // MARK: Properties
    
    var menu: NSMenu!
    
    var isAutoOpen: Bool {
        get {
            return UserDefaults.standard.bool(forKey: autoOpenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: autoOpenKey)
        }
    }
    
    var controller: Controller!
    
    var dialItems: [DialMenuItem] = []
    
    lazy var autoOpenItem: NSMenuItem = {
        let item = NSMenuItem(title: "open_at_login".localized,
                              action: #selector(toggleAutoOpen),
                              keyEquivalent: String())
        item.state = UserDefaults.standard.bool(forKey: autoOpenKey) ? .on : .off
        return item
    }()
    
    lazy var quitItem: QuitMenuItem = {
        return QuitMenuItem()
    }()
    
    lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button
        {
            button.image = NSImage.statusItemDialWithInterval(interval: defaultInterval, rotations: 0)
        }
        
        return statusItem
    }()
    
    lazy var addItem: NSMenuItem = {
        let addItem = NSMenuItem(title: "New Timer", action: #selector(addTimer(sender:)), keyEquivalent: "a")
        return addItem
    }()
    
    @objc func addTimer(sender: Any?)
    {
        let timer = DialMenuItem(delegate: controller, width: menu.size.width)
        
        dialItems.append(timer)
        
        menu.insertItem(NSMenuItem.separator(), at: (dialItems.count - 1) * 2 - 1)
        menu.insertItem(timer.menuItem, at: (dialItems.count - 1) * 2)
    }
    
    @objc func toggleAutoOpen()
    {
        autoOpenItem.state = isAutoOpen ? .off : .on
        
        if SMLoginItemSetEnabled(launcherKey as CFString, !isAutoOpen)
        {
            isAutoOpen = !isAutoOpen
        }
    }
    
    // MARK: Application Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        controller = Controller(delegate: self)
        
        menu = NSMenu()
        menu.addItem(NSMenuItem.separator())
        menu.addItem(autoOpenItem)
        menu.addItem(quitItem)
        
        dialItems = [DialMenuItem(delegate: controller, width: menu.size.width)]
        
        for item in dialItems
        {
            menu.insertItem(item.menuItem, at: 0)
        }
        
        statusItem.menu = menu
        
        configureElements(dial: nil, totalInterval: defaultInterval, rotations: 0, manual: true)
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any])
    {
        // Will this actually work?
        let cloudService = CloudService()
        
        cloudService.downloadAlarms()
        
//        let dict = userInfo as! [String: NSObject]
//        let notification = CKNotification(fromRemoteNotificationDictionary: dict)
//        let database = cloudService.database
//
//        if notification?.subscriptionID == subscriptionIdentifier
//        {
//            completionHandler(.newData)
//        }
//        else
//        {
//            completionHandler(.noData)
//        }
    }
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print(deviceToken)
    }
    
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print(error.localizedDescription)
    }
}

extension AppDelegate: ControllerDelegate
{
    func configureElements(dial: Dial?, totalInterval: Double, rotations: Int, manual: Bool)
    {
        guard let item = dialItems.first else { return }
        
        item.configureDial(totalInterval: totalInterval, rotations: rotations)
        item.configureLabel(interval: totalInterval)
        
        if manual || Int(totalInterval.truncatingRemainder(dividingBy: 10)) == 0
        {
            statusItem.button?.image = NSImage.statusItemDialWithInterval(interval: totalInterval,
                                                                          rotations: rotations)
        }
    }
}
