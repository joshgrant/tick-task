//
//  RightClickView.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/11/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

protocol RightClickViewDelegate
{
    func rightMouseEvent(with event: NSEvent)
}

class RightClickView: NSView
{
    var delegate: RightClickViewDelegate?
    
    override func rightMouseDown(with event: NSEvent)
    {
        delegate?.rightMouseEvent(with: event)
    }
    
    override func rightMouseUp(with event: NSEvent)
    {
        delegate?.rightMouseEvent(with: event)
    }
}
