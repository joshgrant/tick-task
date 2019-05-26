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
    var topLevelView: NSView
    {
        return self.superview?.topLevelView ?? self
    }
}
