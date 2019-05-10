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
    func imageViewMouseEvent(_ event: NSEvent)
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
    
    override func mouseUp(with event: NSEvent)
    {
        delegate?.imageViewMouseEvent(event)
    }
    
    override func mouseDragged(with event: NSEvent)
    {
        delegate?.imageViewMouseEvent(event)
    }
    
    override func mouseDown(with event: NSEvent)
    {
        delegate?.imageViewMouseEvent(event)
    }
    
    override func rightMouseDown(with event: NSEvent)
    {
        delegate?.imageViewMouseEvent(event)
    }
    
    override func rightMouseDragged(with event: NSEvent)
    {
        delegate?.imageViewMouseEvent(event)
    }
    
    override func rightMouseUp(with event: NSEvent)
    {
        delegate?.imageViewMouseEvent(event)
    }
}
