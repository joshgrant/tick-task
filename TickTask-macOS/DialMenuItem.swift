//
//  DialMenuItem.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/5/19.
//

import Cocoa

class DialMenuView: NSStackView
{
    // MARK: Properties
    
    lazy var menuItem: NSMenuItem = {
        let menuItem = NSMenuItem()
        menuItem.view = self
        return menuItem
    }()
    
    // MARK: Interface Outlets
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var dial: Dial!
    
    // MARK: Initializers
    
    static func initFromNib(delegate: DialDelegate) -> DialMenuView
    {
        var topLevelObjects: NSArray?
        Bundle.main.loadNibNamed("DialMenuView", owner: self, topLevelObjects: &topLevelObjects)
        
        var dialMenuView: DialMenuView!
        
        if let objects = topLevelObjects
        {
            for object in objects
            {
                if let possibleMenu = object as? DialMenuView
                {
                    dialMenuView = possibleMenu
                }
            }
        }
        
        dialMenuView.dial.delegate = delegate
        dialMenuView.dial.allowsMixedState = true
        dialMenuView.dial.state = .off
        
        return dialMenuView
    }
    
    // MARK: Configuration
    
    func configureLabel(interval: Double)
    {
        label.stringValue = interval.durationString
    }
    
    func configureDial(interval: Double)
    {
        guard let dialView = dial.controlView else { return }
        
        dialView.setNeedsDisplay(dialView.frame)
    }
}
