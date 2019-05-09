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
        let image = NSImage(size: size, flipped: false) { (rect) -> Bool in
            
            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            
            // Draw the border of the timer
            let borderPath = NSBezierPath(ovalIn: NSRect(x: 3.5, y: 3.5, width: 16, height: 16))
            borderPath.lineWidth = 1
            NSColor.controlTextColor.setStroke()
            borderPath.stroke()
            
            // Update the graphics context
            
            NSGraphicsContext.saveGraphicsState()
            context.translateBy(x: 11.5, y: 11.5)
            context.rotate(by: angle)
            
            // Draw the dial of the timer
            let dialPath = NSBezierPath()
            dialPath.move(to: NSPoint(x: -1.23, y: 0.3))
            
            dialPath.curve(to: NSPoint(x: -0.38, y: 5.26),
                           controlPoint1: NSPoint(x: -0.8, y: 2.88),
                           controlPoint2: NSPoint(x: -0.43, y: 5.06))
            dialPath.curve(to: NSPoint(x: -0.01, y: 5.6),
                           controlPoint1: NSPoint(x: -0.34, y: 5.46),
                           controlPoint2: NSPoint(x: -0.2, y: 5.6))
            dialPath.curve(to: NSPoint(x: 0.37, y: 5.26),
                           controlPoint1: NSPoint(x: 0.19, y: 5.6),
                           controlPoint2: NSPoint(x: 0.33, y: 5.46))
            dialPath.curve(to: NSPoint(x: 1.22, y: 0.3),
                           controlPoint1: NSPoint(x: 0.42, y: 5.06),
                           controlPoint2: NSPoint(x: 0.79, y: 2.88))
            dialPath.curve(to: NSPoint(x: -0.01, y: -1.27),
                           controlPoint1: NSPoint(x: 1.37, y: -0.58),
                           controlPoint2: NSPoint(x: 0.71, y: -1.27))
            dialPath.curve(to: NSPoint(x: -1.23, y: 0.3),
                           controlPoint1: NSPoint(x: -0.72, y: -1.27),
                           controlPoint2: NSPoint(x: -1.38, y: -0.58))
            
            dialPath.close()
            dialPath.windingRule = .evenOdd
            
            NSColor.controlTextColor.setFill()
            dialPath.fill()
            
            NSGraphicsContext.restoreGraphicsState()
            
            return true
        }
        
        return image
    }
}

extension NSImage
{
    static func interactionDialWithRotation(angle: CGFloat, state: DialState) -> NSImage
    {
        let size = CGSize(width: 108, height: 108)
        let image = NSImage(size: size, flipped: false) { (rect) -> Bool in
            let context = NSGraphicsContext.current!.cgContext
            
            //// Color Declarations
            
            let dialFillColor: NSColor
            
            switch state
            {
            case .inactive:
                dialFillColor = NSColor.systemGreen
            case .userDragging:
                dialFillColor = NSColor.systemYellow
            case .countdown:
                dialFillColor = NSColor.systemRed
            }
            
            let dialFill = dialFillColor //NSColor(red: 0.459, green: 0.778, blue: 0.505, alpha: 1)
            let dialShadow = dialFill.blended(withFraction: 0.6, of: NSColor.black)!
            let color = dialFill.blended(withFraction: 0.4, of: NSColor.white)!
            let color3 = NSColor.controlBackgroundColor.blended(withFraction: 0.3, of: .clear)!
            let gradientColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            let reverseColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.25)
            
            //// Gradient Declarations
            let gradient = NSGradient(starting: gradientColor, ending: reverseColor)!
            let reverse = NSGradient(starting: reverseColor, ending: gradientColor)!
            
            //// Shadow Declarations
            let shadow = NSShadow()
            shadow.shadowColor = dialShadow.withAlphaComponent(0.5 * dialShadow.alphaComponent)
            shadow.shadowOffset = NSSize(width: 0, height: 2)
            shadow.shadowBlurRadius = 0
            let shadow2 = NSShadow()
            shadow2.shadowColor = color
            shadow2.shadowOffset = NSSize(width: 0, height: 2)
            shadow2.shadowBlurRadius = 0
            let borderShadow = NSShadow()
            borderShadow.shadowColor = NSColor.controlShadowColor
            borderShadow.shadowOffset = NSSize(width: 0, height: 2)
            borderShadow.shadowBlurRadius = 4
            
            //// Oval 5 Drawing
            let oval5Path = NSBezierPath(ovalIn: NSRect(x: 4, y: 6, width: 100, height: 100))
            NSGraphicsContext.saveGraphicsState()
            borderShadow.set()
            color3.setFill()
            oval5Path.fill()
            NSGraphicsContext.restoreGraphicsState()
            
            
            
            //// Oval Drawing
            let ovalPath = NSBezierPath(ovalIn: NSRect(x: 4, y: 6, width: 100, height: 100))
            reverse.draw(in: ovalPath, angle: -90)
            
            
            //// Oval 4 Drawing
            let oval4Path = NSBezierPath(ovalIn: NSRect(x: 6, y: 8, width: 96, height: 96))
            color3.setFill()
            oval4Path.fill()
            
            
            //// Oval 2 Drawing
            let oval2Path = NSBezierPath(ovalIn: NSRect(x: 8, y: 10, width: 92, height: 92))
            gradient.draw(in: oval2Path, angle: -90)
            
            
            //// Oval 3 Drawing
            let oval3Path = NSBezierPath(ovalIn: NSRect(x: 10, y: 12, width: 88, height: 88))
            color3.setFill()
            oval3Path.fill()
            
            
            //// Bezier 2 Drawing
            NSGraphicsContext.saveGraphicsState()
            context.translateBy(x: 54, y: 58)
            context.rotate(by: angle)
            
            let bezier2Path = NSBezierPath()
            bezier2Path.move(to: NSPoint(x: -0, y: 4))
            bezier2Path.curve(to: NSPoint(x: -4, y: -0), controlPoint1: NSPoint(x: -2.21, y: 4), controlPoint2: NSPoint(x: -4, y: 2.21))
            bezier2Path.curve(to: NSPoint(x: -0, y: -4), controlPoint1: NSPoint(x: -4, y: -2.21), controlPoint2: NSPoint(x: -2.21, y: -4))
            bezier2Path.line(to: NSPoint(x: 0.05, y: -4))
            bezier2Path.curve(to: NSPoint(x: 4, y: -0), controlPoint1: NSPoint(x: 2.24, y: -3.97), controlPoint2: NSPoint(x: 4, y: -2.19))
            bezier2Path.curve(to: NSPoint(x: -0, y: 4), controlPoint1: NSPoint(x: 4, y: 2.21), controlPoint2: NSPoint(x: 2.21, y: 4))
            bezier2Path.close()
            bezier2Path.move(to: NSPoint(x: 2.72, y: 35.7))
            bezier2Path.curve(to: NSPoint(x: 8.85, y: 1.76), controlPoint1: NSPoint(x: 3.05, y: 34.34), controlPoint2: NSPoint(x: 5.7, y: 19.39))
            bezier2Path.curve(to: NSPoint(x: -0, y: -9), controlPoint1: NSPoint(x: 9.92, y: -4.29), controlPoint2: NSPoint(x: 5.18, y: -9))
            bezier2Path.curve(to: NSPoint(x: -8.81, y: -1.77), controlPoint1: NSPoint(x: -4.11, y: -9), controlPoint2: NSPoint(x: -7.94, y: -6))
            bezier2Path.curve(to: NSPoint(x: -8.85, y: 1.76), controlPoint1: NSPoint(x: -9.04, y: -0.67), controlPoint2: NSPoint(x: -9.07, y: 0.52))
            bezier2Path.curve(to: NSPoint(x: -5.05, y: 23.05), controlPoint1: NSPoint(x: -7.42, y: 9.74), controlPoint2: NSPoint(x: -6.1, y: 17.18))
            bezier2Path.curve(to: NSPoint(x: -2.72, y: 35.7), controlPoint1: NSPoint(x: -3.78, y: 30.14), controlPoint2: NSPoint(x: -2.9, y: 34.96))
            bezier2Path.curve(to: NSPoint(x: -0, y: 38), controlPoint1: NSPoint(x: -2.39, y: 37.06), controlPoint2: NSPoint(x: -1.4, y: 38))
            bezier2Path.curve(to: NSPoint(x: 2.72, y: 35.7), controlPoint1: NSPoint(x: 1.39, y: 38), controlPoint2: NSPoint(x: 2.39, y: 37.06))
            bezier2Path.close()
            NSGraphicsContext.saveGraphicsState()
            shadow.set()
            dialFill.setFill()
            bezier2Path.fill()
            
            ////// Bezier 2 Inner Shadow
            NSGraphicsContext.saveGraphicsState()
            bezier2Path.bounds.clip()
            context.setShadow(offset: NSSize.zero, blur: 0, color: nil)
            
            context.setAlpha(shadow2.shadowColor!.alphaComponent)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            let bezier2OpaqueShadow = NSShadow()
            bezier2OpaqueShadow.shadowColor = shadow2.shadowColor!.withAlphaComponent(1)
            bezier2OpaqueShadow.shadowOffset = shadow2.shadowOffset
            bezier2OpaqueShadow.shadowBlurRadius = shadow2.shadowBlurRadius
            bezier2OpaqueShadow.set()
            
            context.setBlendMode(.sourceOut)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            
            bezier2OpaqueShadow.shadowColor!.setFill()
            bezier2Path.fill()
            
            context.endTransparencyLayer()
            context.endTransparencyLayer()
            NSGraphicsContext.restoreGraphicsState()
            
            NSGraphicsContext.restoreGraphicsState()
            
            
            NSGraphicsContext.restoreGraphicsState()
            return true
        }
        
        return image
    }
}
