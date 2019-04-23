//
//  AppDelegate.swift
//  TickTask
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        let viewController = initializeViewController()
        let menu = initializeMenu(viewController: viewController)
        
        statusItem = initializeStatusItem(menu: menu)
    }
    
    func initializeStatusItem(menu: NSMenu) -> NSStatusItem
    {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button
        {
            button.image = NSImage(named: "status-bar-icon")
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
        
        let viewControllerItem = initializeViewControllerMenuItem(viewController: viewController)
        let quitItem = initializeQuitMenuItem()
        
        menu.addItem(viewControllerItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitItem)
        
        return menu
    }
    
    func initializeViewControllerMenuItem(viewController: ViewController) -> NSMenuItem
    {
        let item = NSMenuItem()
        
        item.view = viewController.view
        
        return item
    }
    
    func initializeQuitMenuItem() -> NSMenuItem
    {
        let title = "Quit"
        let selector = #selector(NSApplication.terminate(_:))
        let keyEquivalent = "q"
        
        let item = NSMenuItem(title: title, action: selector, keyEquivalent: keyEquivalent)
        
        return item
    }
    
    // MARK: Application Termination
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply
    {
        let context = Database.container.viewContext
        
        if !context.commitEditing()
        {
            return .terminateCancel
        }
        
        if !context.hasChanges
        {
            return .terminateNow
        }
        
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving state during application quit: \(error)")
            
            return .terminateCancel
        }
        
        return .terminateNow
    }
}
