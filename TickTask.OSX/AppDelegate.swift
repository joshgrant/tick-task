//
//  AppDelegate.swift
//  TickTask
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa
import ServiceManagement

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
    
    var dialMenuItem: DialMenuItem!
    
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
    
    // MARK: Application Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        controller = Controller(delegate: self)
        
        menu = NSMenu()
        menu.addItem(NSMenuItem.separator())
        menu.addItem(autoOpenItem)
        menu.addItem(quitItem)
        
        dialMenuItem = DialMenuItem(delegate: controller, width: menu.size.width)
        
        menu.insertItem(dialMenuItem.menuItem, at: 0)
        
        statusItem.menu = menu
        
        configureElements(totalInterval: defaultInterval, rotations: 0, manual: true)
    }
    
    @objc func toggleAutoOpen()
    {
        autoOpenItem.state = isAutoOpen ? .off : .on
        
        if SMLoginItemSetEnabled(launcherKey as CFString, !isAutoOpen)
        {
            isAutoOpen = !isAutoOpen
        }
    }
}

extension AppDelegate: ControllerDelegate
{
    func configureElements(totalInterval: Double, rotations: Int, manual: Bool)
    {
        dialMenuItem.configureDial(totalInterval: totalInterval, rotations: rotations)
        dialMenuItem.configureLabel(interval: totalInterval)
        
        if manual || totalInterval.truncatingRemainder(dividingBy: 10) == 0
        {
            statusItem.button?.image = NSImage.statusItemDialWithInterval(interval: totalInterval, rotations: rotations)
        }
    }
}
