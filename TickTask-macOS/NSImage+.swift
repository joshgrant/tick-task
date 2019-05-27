//
//  NSImage+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa
import CoreGraphics

extension NSImage
{
    static func statusItemDialWithRotation(angle: CGFloat) -> NSImage
    {
        let size = CGSize(width: 22, height: 22)
        let image = NSImage(size: size, flipped: true) { (rect) -> Bool in
            
            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            
            let borderRect = NSRect(x: 3.5, y: 3.5, width: 16, height: 16)
            
            let drawingData = DrawingData(rect: borderRect)
            
            let borderPath = NSBezierPath(ovalIn: borderRect)
            borderPath.lineWidth = 1
            NSColor.controlTextColor.setStroke()
            borderPath.stroke()
            
            // Update the graphics context
            
            context.pushPop {
                context.translateBy(x: 11.5, y: 11.5)
                context.rotate(by: angle)
                
                let path = DialShape.dialPath(drawingData: drawingData, withCenter: false)
                path.windingRule = .evenOdd
                NSColor.controlTextColor.setFill()
                path.fill()
            }
            
//            NSGraphicsContext.saveGraphicsState()
//            context.translateBy(x: 11.5, y: 11.5)
//            context.rotate(by: angle)
            
//            // Draw the dial of the timer
//            let dialPath = NSBezierPath()
//            dialPath.move(to: NSPoint(x: -1.23, y: 0.3))
//
//            dialPath.curve(to: NSPoint(x: -0.38, y: 5.26),
//                           controlPoint1: NSPoint(x: -0.8, y: 2.88),
//                           controlPoint2: NSPoint(x: -0.43, y: 5.06))
//            dialPath.curve(to: NSPoint(x: -0.01, y: 5.6),
//                           controlPoint1: NSPoint(x: -0.34, y: 5.46),
//                           controlPoint2: NSPoint(x: -0.2, y: 5.6))
//            dialPath.curve(to: NSPoint(x: 0.37, y: 5.26),
//                           controlPoint1: NSPoint(x: 0.19, y: 5.6),
//                           controlPoint2: NSPoint(x: 0.33, y: 5.46))
//            dialPath.curve(to: NSPoint(x: 1.22, y: 0.3),
//                           controlPoint1: NSPoint(x: 0.42, y: 5.06),
//                           controlPoint2: NSPoint(x: 0.79, y: 2.88))
//            dialPath.curve(to: NSPoint(x: -0.01, y: -1.27),
//                           controlPoint1: NSPoint(x: 1.37, y: -0.58),
//                           controlPoint2: NSPoint(x: 0.71, y: -1.27))
//            dialPath.curve(to: NSPoint(x: -1.23, y: 0.3),
//                           controlPoint1: NSPoint(x: -0.72, y: -1.27),
//                           controlPoint2: NSPoint(x: -1.38, y: -0.58))
//
//            dialPath.close()
//            dialPath.windingRule = .evenOdd
//            NSColor.controlTextColor.setFill()
//            dialPath.fill()
            
//            NSGraphicsContext.restoreGraphicsState()
            
            return true
        }
        image.isTemplate = true
        return image
    }
}
