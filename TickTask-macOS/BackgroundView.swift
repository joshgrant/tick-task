//
//  BackgroundView.swift
//  TickTask
//
//  Created by Joshua Grant on 6/2/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

protocol BackgroundViewDelegate
{
    func backgroundViewMouseEvent(_ event: NSEvent)
}

class BackgroundView: NSView
{
    var delegate: BackgroundViewDelegate?
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { return true }
    override var acceptsFirstResponder: Bool { return true }
    override func mouseUp(with event: NSEvent) { delegate?.backgroundViewMouseEvent(event) }
    override func mouseDragged(with event: NSEvent) { delegate?.backgroundViewMouseEvent(event) }
    override func mouseDown(with event: NSEvent) { delegate?.backgroundViewMouseEvent(event) }
    override func rightMouseDown(with event: NSEvent) { delegate?.backgroundViewMouseEvent(event) }
    override func rightMouseDragged(with event: NSEvent) { delegate?.backgroundViewMouseEvent(event) }
    override func rightMouseUp(with event: NSEvent) { delegate?.backgroundViewMouseEvent(event) }
}
