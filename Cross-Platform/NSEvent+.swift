//
//  NSEvent+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/27/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

extension NSEvent
{
    var rightMouseOrModifierKey: Bool {
        return type == .rightMouseUp
            || type == .rightMouseDown
            || type == .rightMouseDragged
            || modifierFlags != .init(rawValue: 0)
    }
}
