//
//  AutoOpenMenuItem.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/5/19.
//

import Cocoa
import ServiceManagement

class AutoOpenMenuItem: NSMenuItem
{
    // MARK: Properties
    
    var isAutoOpen: Bool {
        return UserDefaults.standard.bool(forKey: autoOpenKey)
    }
    
    // MARK: Initializers
    
    convenience init()
    {
        self.init(title: "open_at_login".localized,
                  action: #selector(toggleAutoOpen),
                  keyEquivalent: String())
        
        state = isAutoOpen ? .on : .off
    }
    
    // MARK: Functions
    
    @objc func toggleAutoOpen()
    {
        state = isAutoOpen ? .off : .on
        
        if SMLoginItemSetEnabled(launcherKey as CFString, !isAutoOpen)
        {
            UserDefaults.standard.set(!isAutoOpen, forKey: autoOpenKey)
        }
    }
}
