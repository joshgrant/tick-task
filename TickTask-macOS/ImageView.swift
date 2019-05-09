//
//  ImageView.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/9/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

class ImageView: NSImageView
{
    // We need this so that the gesture recognizers work???
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool
    {
        return true
    }
}

// In the future, we might need to subclass the view to make sure that
// we can accept first responder. But for now, this works well...
