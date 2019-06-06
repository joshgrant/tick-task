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
    var timerService: TimerService!
    var notificationService: NotificationService!
    
    lazy var dialMenuView: DialMenuView = {
        return DialMenuView.initFromNib(delegate: self)
    }()
    
    lazy var optionsMenuView: OptionsMenuView = {
        return OptionsMenuView.initFromNib(delegate: self)
    }()
    
    lazy var autoOpenItem: AutoOpenMenuItem = {
        return AutoOpenMenuItem()
    }()
    
    lazy var quitItem: QuitMenuItem = {
        return QuitMenuItem()
    }()
    
    lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button
        {
            button.image = NSImage.statusItemDialWithInterval(interval: defaultInterval)
        }
        
        return statusItem
    }()
    
    // MARK: Application Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        timerService = TimerService()
        notificationService = NotificationService()
        
        menu = NSMenu()
        menu.addItem(dialMenuView.menuItem)
        menu.addItem(optionsMenuView.menuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(autoOpenItem)
        menu.addItem(quitItem)
        
        statusItem.menu = menu
        
        notificationService.requestAuthorizationToDisplayNotifications()
        
        configureElements()
    }
    
    func configureElements(interval: Double? = nil, manual: Bool = true)
    {
        let interval: Double = interval ?? timerService.currentInterval
        
        dialMenuView.configureDial(interval: interval)
        dialMenuView.configureLabel(interval: interval)
        
        if manual || interval.truncatingRemainder(dividingBy: 10) == 0
        {
            statusItem.button?.image = NSImage.statusItemDialWithInterval(interval: interval)
        }
    }
}

extension AppDelegate: DialDelegate
{
    func dialStartedTracking(dial: Dial)
    {
        dial.state = .mixed
        
        timerService.invalidateTimersAndDates()
        
        configureElements(interval: dial.doubleValue)
    }
    
    func dialUpdatedTracking(dial: Dial)
    {
        dial.state = .mixed
        
        configureElements(interval: dial.doubleValue)
    }
    
    func dialStoppedTracking(dial: Dial)
    {
        if dial.doubleValue == 0
        {
            dial.state = .off
            
            timerService.invalidateTimersAndDates()
        }
        else
        {
            dial.state = .on
            
            timerService.setTimerToActive(interval: dial.doubleValue) { (timer) in
                if self.timerService.currentInterval <= 0
                {
                    dial.state = .off
                    self.timerService.invalidateTimersAndDates()
                    
                    self.configureElements(interval: dial.doubleValue, manual: false)
                }
                else
                {
                    self.configureElements(manual: false)
                }
            }
            
            notificationService.createNotification(at: dial.doubleValue)
        }
        
        configureElements(interval: dial.doubleValue)
    }
}

extension AppDelegate: OptionsMenuDelegate
{
    
}
