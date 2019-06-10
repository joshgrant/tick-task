//
//  main.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/6/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

autoreleasepool {
    
    let delegate = AppDelegate()
    
    withExtendedLifetime(delegate, {
        let app = NSApplication.shared
        
        app.setActivationPolicy(.accessory)
        app.delegate = delegate
        app.run()
        
        app.delegate = nil
    })
}
