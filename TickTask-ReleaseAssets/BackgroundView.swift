//
//  BackgroundView.swift
//  TickTask-ReleaseAssets
//
//  Created by Joshua Grant on 5/29/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

@IBDesignable class BackgroundView: NSView
{
    @IBInspectable var background: NSColor = .clear
    @IBInspectable var corner: CGFloat = 0
    @IBInspectable var shadowColor: NSColor = .black
    @IBInspectable var shadowOffset: NSSize = .zero
    @IBInspectable var shadowBlur: CGFloat = 0
    
    override func draw(_ dirtyRect: NSRect)
    {
        layer?.masksToBounds = false
        let path = NSBezierPath(roundedRect: CGRect(x: shadowBlur, y: 0, width: dirtyRect.width - shadowBlur * 2, height: dirtyRect.height - shadowBlur), xRadius: corner, yRadius: corner)
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowBlurRadius = shadowBlur
        shadow.shadowOffset = shadowOffset
        shadow.set()
        background.setFill()
        path.fill()
        super.draw(dirtyRect)
    }
}
