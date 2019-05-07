//
//  NSView+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

extension NSView
{
    var center: NSPoint {
        get {
            return NSPoint(x: self.bounds.size.width / 2.0,
                           y: self.bounds.size.height / 2.0)
        }
    }
}
