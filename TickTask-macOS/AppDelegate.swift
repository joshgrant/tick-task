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
    // MARK: Shared Variables
    
    var statusItem: NSStatusItem!
    var viewController: ViewController!
    var menu: NSMenu!

    // MARK: Application Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        viewController = initializeViewController()
        menu = initializeMenu(viewController: viewController)
        statusItem = initializeStatusItem(menu: menu)
        
        viewController.statusItem = statusItem
    }
    
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

// MARK: Object Initialization

extension AppDelegate
{
    func initializeStatusItem(menu: NSMenu) -> NSStatusItem
    {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button
        {
            button.image = StatusBarIconView.imageWithRotation(angle: 0)
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
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitMenuItem())
        
        let item = NSMenuItem(title: "Hello", action: #selector(sex), keyEquivalent: "r")
        item.keyEquivalentModifierMask = .option
        item.allowsKeyEquivalentWhenHidden = true
        item.isHidden = true
//        item.
        
        menu.addItem(item)
        
        return menu
    }
    
    @objc func sex()
    {
        print("Sex")
    }
    
    func viewControllerMenuItem(viewController: ViewController) -> NSMenuItem
    {
        let item = NSMenuItem()
        
        item.view = viewController.view
        
        return item
    }
    
    func quitMenuItem() -> NSMenuItem
    {
        let title = "Quit"
        let selector = #selector(NSApplication.terminate(_:))
        let keyEquivalent = "q"
        
        let item = NSMenuItem(title: title, action: selector, keyEquivalent: keyEquivalent)
        
        return item
    }
}
