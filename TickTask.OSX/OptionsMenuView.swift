//
//  OptionsMenuItem.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/6/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

protocol OptionsMenuDelegate
{
    
}

class OptionsMenuView: NSView
{
    // MARK: Properties
    
    var optionsMenuDelegate: OptionsMenuDelegate?
    
    lazy var menuItem: NSMenuItem = {
        let menuItem = NSMenuItem()
        menuItem.view = self
        return menuItem
    }()
    
    // MARK: Interface Outlets
    
    @IBOutlet weak var loopButton: NSButton!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var warningButton: NSButton!
    
    // MARK: Initializers
    
    static func initFromNib(delegate: OptionsMenuDelegate) -> OptionsMenuView
    {
        var topLevelObjects: NSArray?
        Bundle.main.loadNibNamed("OptionsMenuView", owner: self, topLevelObjects: &topLevelObjects)
        
        var optionsMenuView: OptionsMenuView!
        
        if let objects = topLevelObjects
        {
            for object in objects
            {
                if let possibleMenu = object as? OptionsMenuView
                {
                    optionsMenuView = possibleMenu
                }
            }
        }
        
        optionsMenuView.optionsMenuDelegate = delegate
        
        return optionsMenuView
    }
}
