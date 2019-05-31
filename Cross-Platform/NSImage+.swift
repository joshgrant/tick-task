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
    static func statusItemDialWithRotation(angle: CGFloat, size: CGSize = CGSize(square: 22)) -> NSImage
    {
        let image = NSImage(size: size, flipped: true) { (rect) -> Bool in
            
            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            
            let scaleFactor = size.width / 22.0
            
            let borderRect = NSRect(x: 3.5 * scaleFactor,
                                    y: 2.5 * scaleFactor,
                                    width: 16 * scaleFactor,
                                    height: 16 * scaleFactor)
            
            let drawingData = DrawingData(rect: borderRect)
            
            let borderPath = NSBezierPath(ovalIn: borderRect)
            borderPath.lineWidth = 1 * scaleFactor
            NSColor.white.setStroke()
            borderPath.stroke()
            
            // Update the graphics context
            
            context.pushPop {
                context.translateBy(x: 11.5 * scaleFactor, y: 10.5 * scaleFactor)
                context.rotate(by: angle)
                
                let path = DialShape.dialPath(drawingData: drawingData, withCenter: false)
                path.windingRule = .evenOdd
                NSColor.white.setFill()
                path.fill()
            }
            
            return true
        }
        image.isTemplate = true
        return image
    }
}
