//
//  StatusBarIconView.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/1/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa
import CoreGraphics

class StatusBarIconView: NSView
{
    static func imageWithRotation(angle: CGFloat) -> NSImage
    {
        
        let imageSize = CGSize(width: 22, height: 22)
        
        let image = NSImage(size: imageSize, flipped: false) { (rect) -> Bool in
            
            self.drawCanvas1(angle: angle)
            return true
        }
        
        return image
    }
    
    // I need to clean up this code...
    static func drawCanvas1(angle: CGFloat = 0)
    {
        //// General Declarations
        let context = NSGraphicsContext.current!.cgContext
        
        //// Color Declarations
        let fillColor3 = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        //// Oval Drawing
        let ovalPath = NSBezierPath(ovalIn: NSRect(x: 3.5, y: 3.5, width: 16, height: 16))
        NSColor.white.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
        
        
        //// Path-Copy-3 Drawing
        NSGraphicsContext.saveGraphicsState()
        context.translateBy(x: 11.5, y: 11.5)
        context.rotate(by: angle)
        
        let pathCopy3Path = NSBezierPath()
        pathCopy3Path.move(to: NSPoint(x: -1.23, y: 0.3))
        pathCopy3Path.curve(to: NSPoint(x: -0.38, y: 5.26), controlPoint1: NSPoint(x: -0.8, y: 2.88), controlPoint2: NSPoint(x: -0.43, y: 5.06))
        pathCopy3Path.curve(to: NSPoint(x: -0.01, y: 5.6), controlPoint1: NSPoint(x: -0.34, y: 5.46), controlPoint2: NSPoint(x: -0.2, y: 5.6))
        pathCopy3Path.curve(to: NSPoint(x: 0.37, y: 5.26), controlPoint1: NSPoint(x: 0.19, y: 5.6), controlPoint2: NSPoint(x: 0.33, y: 5.46))
        pathCopy3Path.curve(to: NSPoint(x: 1.22, y: 0.3), controlPoint1: NSPoint(x: 0.42, y: 5.06), controlPoint2: NSPoint(x: 0.79, y: 2.88))
        pathCopy3Path.curve(to: NSPoint(x: -0.01, y: -1.27), controlPoint1: NSPoint(x: 1.37, y: -0.58), controlPoint2: NSPoint(x: 0.71, y: -1.27))
        pathCopy3Path.curve(to: NSPoint(x: -1.23, y: 0.3), controlPoint1: NSPoint(x: -0.72, y: -1.27), controlPoint2: NSPoint(x: -1.38, y: -0.58))
        pathCopy3Path.close()
        pathCopy3Path.windingRule = .evenOdd
        fillColor3.setFill()
        pathCopy3Path.fill()
        
        NSGraphicsContext.restoreGraphicsState()
    }
}
