//
//  ImageView.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/9/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

protocol ImageViewMouseDelegate
{
    func imageViewMouseDown(with event: NSEvent)
    func imageViewMouseDragged(with event: NSEvent)
    func imageViewMouseUp(with event: NSEvent)
    
    func imageViewRightMouseDown(with event: NSEvent)
    func imageViewRightMouseDragged(with event: NSEvent)
    func imageViewRightMouseUp(with event: NSEvent)
}

class ImageView: NSImageView
{
    var delegate: ImageViewMouseDelegate?
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool
    {
        return true
    }
    
    override var acceptsFirstResponder: Bool
    {
        return true
    }
    
    override func mouseUp(with event: NSEvent) {
        delegate?.imageViewMouseUp(with: event)
    }
    
    override func mouseDragged(with event: NSEvent)
    {
        delegate?.imageViewMouseDragged(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.imageViewMouseDown(with: event)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        delegate?.imageViewRightMouseDown(with: event)
    }
    
    override func rightMouseDragged(with event: NSEvent)
    {
        delegate?.imageViewRightMouseDragged(with: event)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        delegate?.imageViewRightMouseUp(with: event)
    }
}

// In the future, we might need to subclass the view to make sure that
// we can accept first responder. But for now, this works well...
