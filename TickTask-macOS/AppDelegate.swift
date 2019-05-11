//
//  AppDelegate.swift
//  TickTask
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    // MARK: Shared Variables
    
    static let autoOpenKey = "me.joshgrant.TickTask.isAutoOpen"
    static let launcherKey = "me.joshgrant.TickTask-macOSLauncher"
    
    var statusItem: NSStatusItem!
    var viewController: ViewController!
    var menu: NSMenu!
    
    var autoOpenItem: NSMenuItem!

    // MARK: Application Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        viewController = initializeViewController()
        menu = initializeMenu(viewController: viewController)
        statusItem = initializeStatusItem(menu: menu)
        
        viewController.statusItem = statusItem
    }
}

// MARK: Object Initialization

//class StatusBarButton: NSStatusBarButton
//{
//    override func mouseDown(with event: NSEvent)
//    {
//        print("MOuse down")
//    }
//
//    override func mouseUp(with event: NSEvent)
//    {
//        print("Mouse up")
//    }
//}

extension AppDelegate
{
    func initializeStatusItem(menu: NSMenu) -> NSStatusItem
    {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
//        statusItem.button = StatusBarButton(image: NSImage.statusItemDialWithRotation(angle: 0), target: self, action: #selector(statusItemButtonRightClick(sender:)))
        
        if let button = statusItem.button
        {
            button.image = NSImage.statusItemDialWithRotation(angle: 0)
//            button.action = #selector(hello)
//
//            let rightClick = NSClickGestureRecognizer(target: self, action: #selector(statusItemButtonRightClick(sender:)))
//            rightClick.buttonMask = kIOTimingIDSony_1600x1024_76hz
//            button.addGestureRecognizer(rightClick)
        }

//        statusItem.action
        
        statusItem.menu = menu
        
        return statusItem
    }
    
//    @objc func hello()
//    {
//        print("HEllo")
//    }
//    
//    @objc func statusItemButtonRightClick(sender: NSStatusBarButton)
//    {
//        print("SEX")
//    }
//    
    func initializeViewController() -> ViewController
    {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateController(withIdentifier: "ViewController")
        return viewController as! ViewController
    }
    
    func initializeMenu(viewController: ViewController) -> NSMenu
    {
        let menu = NSMenu()

        menu.addItem(viewControllerMenuItem(viewController: viewController))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(openMenuItem())
        menu.addItem(quitMenuItem())
        
        return menu
    }
    
    func viewControllerMenuItem(viewController: ViewController) -> NSMenuItem
    {
        let item = NSMenuItem()
        
        item.view = viewController.view
        
        return item
    }
    
    func quitMenuItem() -> NSMenuItem
    {
        let title = NSLocalizedString("Quit", comment: "")
        // TODO: Remove all notifications...
        let selector = #selector(NSApplication.terminate(_:))
        let keyEquivalent = "q"
        
        let item = NSMenuItem(title: title, action: selector, keyEquivalent: keyEquivalent)
        
        return item
    }
    
    func openMenuItem() -> NSMenuItem
    {
        let title = NSLocalizedString("Auto Open", comment: "")
        let selector = #selector(autoOpen)
        
        autoOpenItem = NSMenuItem()
        autoOpenItem.title = title
        autoOpenItem.action = selector
        
        let autoOpen = UserDefaults.standard.bool(forKey: AppDelegate.autoOpenKey)
        autoOpenItem.state = autoOpen ? .on : .off
        
        return autoOpenItem
    }
    
    @objc func autoOpen()
    {
        if autoOpenItem.state == .on
        {
            autoOpenItem.state = .off
            if SMLoginItemSetEnabled(AppDelegate.launcherKey as CFString, false)
            {
                UserDefaults.standard.set(false, forKey: AppDelegate.autoOpenKey)
            }
        }
        else
        {
            autoOpenItem.state = .on
            if SMLoginItemSetEnabled(AppDelegate.launcherKey as CFString, true)
            {
                UserDefaults.standard.set(true, forKey: AppDelegate.autoOpenKey)
            }
        }
    }
}
