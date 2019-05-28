//
//  GradientView.swift
//  TickTask-ReleaseAssets
//
//  Created by Joshua Grant on 5/28/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

@IBDesignable class GradientView: NSView
{
    @IBInspectable var startingColor: NSColor = NSColor(hue: 128.0 / 360.0,
                                                        saturation: 0.57,
                                                        brightness: 1.0,
                                                        alpha: 1.0)
    
    @IBInspectable var endingColor: NSColor = NSColor(hue: 160.0 / 360.0,
                                                      saturation: 1.0,
                                                      brightness: 1.0,
                                                      alpha: 1.0)
    
    @IBInspectable var angle: CGFloat = 45

    override func draw(_ dirtyRect: NSRect)
    {
        let gradient = NSGradient(starting: startingColor,
                                  ending: endingColor)
        
        let path = NSBezierPath(rect: dirtyRect)
        gradient?.draw(in: path, angle: angle)
    }
}
