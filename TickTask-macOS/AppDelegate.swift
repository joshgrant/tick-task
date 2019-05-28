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
    var contextMenu: NSMenu!
    
    var autoOpenItem: NSMenuItem!
    
    // MARK: Application Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        viewController = initializeViewController()
        menu = initializeMenu(viewController: viewController)
        contextMenu = initializeContextMenu()
        statusItem = initializeStatusItem(menu: menu)
        
        viewController.statusItem = statusItem
    }
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
    }
    
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        debugPrint("Failed to register: \(error)")
    }
}

extension AppDelegate
{
    fileprivate func prerenderStatusBarIcon()
    {
        let angle25Minutes = TimeInterval(exactly: 60 * 25)!.toAngle()
        let angle30Minutes = TimeInterval(exactly: 60 * 30)!.toAngle()
        
        let images: [String: NSImage] = [
            "0_22" : NSImage.statusItemDialWithRotation(angle: 0, size: CGSize(square: 22)),
            "0_44" :  NSImage.statusItemDialWithRotation(angle: 0, size: CGSize(square: 44)),
            "0_66" : NSImage.statusItemDialWithRotation(angle: 0, size: CGSize(square: 66)),
            "25_22" : NSImage.statusItemDialWithRotation(angle: angle25Minutes, size: CGSize(square: 22)),
            "25_44" :  NSImage.statusItemDialWithRotation(angle: angle25Minutes, size: CGSize(square: 44)),
            "25_66" : NSImage.statusItemDialWithRotation(angle: angle25Minutes, size: CGSize(square: 66)),
            "30_22" : NSImage.statusItemDialWithRotation(angle: angle30Minutes, size: CGSize(square: 22)),
            "30_44" :  NSImage.statusItemDialWithRotation(angle: angle30Minutes, size: CGSize(square: 44)),
            "30_66" : NSImage.statusItemDialWithRotation(angle: angle30Minutes, size: CGSize(square: 66)),
        ]
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        print(path)
        
        for (name, image) in images
        {
            FileManager.default.createFile(atPath: "\(path)/\(name).tiff", contents: image.tiffRepresentation, attributes: nil)
        }
    }
}

extension AppDelegate: RightClickViewDelegate
{
    func rightMouseEvent(with event: NSEvent)
    {
        switch event.type
        {
        case .rightMouseDown:
            contextMenu.popUp(positioning: nil, at: NSPoint(x: 0, y: 22), in: statusItem.button)
        default:
            break
        }
    }
}

// MARK: Object Initialization

extension AppDelegate
{
    func initializeStatusItem(menu: NSMenu) -> NSStatusItem
    {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button
        {
            button.image = NSImage.statusItemDialWithRotation(angle: 0)
            
            let rightClickView = RightClickView(frame: button.frame)
            rightClickView.delegate = self
            
            button.addSubview(rightClickView)
        }
        
        statusItem.menu = menu
        
        return statusItem
    }
    
    
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
        
        return menu
    }
    
    func initializeContextMenu() -> NSMenu
    {
        let menu = NSMenu()
        
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
        let title = "quit_ticktask".localized
        let selector = #selector(NSApplication.terminate(_:))
        let keyEquivalent = "q"
        
        let item = NSMenuItem(title: title, action: selector, keyEquivalent: keyEquivalent)
        
        return item
    }
    
    func openMenuItem() -> NSMenuItem
    {
        let title = "open_at_login".localized
        let selector = #selector(autoOpen)
        
        autoOpenItem = NSMenuItem(title: title, action: selector, keyEquivalent: String())
        
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
