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
        image.isTemplate = true
        return image
    }
}

extension NSImage
{
    static func interactionDialWithRotation(angle: CGFloat, state: DialState) -> NSImage
    {
        let size = CGSize(width: 110, height: 110)
        let image = NSImage(size: size, flipped: false) { (rect) -> Bool in
            
            let context = NSGraphicsContext.current!.cgContext
            
            let faceFill: NSColor
            
            switch state {
            case .inactive:
                faceFill = NSColor(calibratedHue: 0.35, saturation: 0.043, brightness: 0.25, alpha: 0.6)
            case .countdown:
                faceFill = NSColor(calibratedHue: 0.0, saturation: 0.043, brightness: 0.25, alpha: 0.6)
            case .userDragging:
                faceFill = NSColor(calibratedHue: 0.15, saturation: 0.043, brightness: 0.25, alpha: 0.6)
            }
            
            //// Color Declarations
            let white20a = NSColor(red: 1, green: 1, blue: 1, alpha: 0.2)
            let highlightTopGradient20aColor = faceFill.blended(withFraction: 0.1, of: NSColor.white)!
            let highlightTopGradient20aColor2 = faceFill.blended(withFraction: 0.1, of: NSColor.black)!
            let highlightBottomGradient20aColor = faceFill.blended(withFraction: 0.1, of: NSColor.white)!
            let highlightBottomGradient20aColor3 = faceFill.blended(withFraction: 0.6, of: NSColor.black)!
            let color = faceFill.blended(withFraction: 0.1, of: NSColor.black)!
            let baseDial = NSColor(hue: faceFill.hueComponent, saturation: faceFill.saturationComponent, brightness: 0.8, alpha: faceFill.alphaComponent)
            let baseDial2 = baseDial.withAlphaComponent(1)
            let baseDial3 = NSColor(hue: baseDial2.hueComponent, saturation: 0.5, brightness: baseDial2.brightnessComponent, alpha: baseDial2.alphaComponent)
            let baseDial4 = baseDial3.blended(withFraction: 0.3, of: NSColor.black)!
            let color3 = faceFill.blended(withFraction: 0.1, of: NSColor.white)!
            let dialInnerShadowColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            let faceBackgroundShadow = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
            
            //// Gradient Declarations
            let highlightTopGradient20a = NSGradient(starting: highlightTopGradient20aColor, ending: highlightTopGradient20aColor2)!
            let highlightBottomGradient20a = NSGradient(starting: highlightBottomGradient20aColor3, ending: highlightBottomGradient20aColor)!
            
            //// Shadow Declarations
            let dialShadow = NSShadow()
            dialShadow.shadowColor = NSColor.black.withAlphaComponent(0.5)
            dialShadow.shadowOffset = NSSize(width: 0, height: 0)
            dialShadow.shadowBlurRadius = 4
            let dialInnerShadow = NSShadow()
            dialInnerShadow.shadowColor = dialInnerShadowColor
            dialInnerShadow.shadowOffset = NSSize(width: 0, height: 2)
            dialInnerShadow.shadowBlurRadius = 0
            let faceShadow = NSShadow()
            faceShadow.shadowColor = faceBackgroundShadow
            faceShadow.shadowOffset = NSSize(width: 0, height: 2)
            faceShadow.shadowBlurRadius = 4
            
            //// Oval 5 Drawing
            let oval5Path = NSBezierPath(ovalIn: NSRect(x: 5, y: 7, width: 100, height: 100))
            NSGraphicsContext.saveGraphicsState()
            faceShadow.set()
            faceFill.setFill()
            oval5Path.fill()
            NSGraphicsContext.restoreGraphicsState()
            
            white20a.setStroke()
            oval5Path.lineWidth = 1
            oval5Path.stroke()
            
            
            //// Oval Drawing
            let ovalPath = NSBezierPath(ovalIn: NSRect(x: 5, y: 7, width: 100, height: 100))
            highlightTopGradient20a.draw(in: ovalPath, angle: -90)
            
            
            //// Oval 4 Drawing
            let oval4Path = NSBezierPath(ovalIn: NSRect(x: 7, y: 9, width: 96, height: 96))
            color3.setFill()
            oval4Path.fill()
            
            
            //// Oval 2 Drawing
            let oval2Path = NSBezierPath(ovalIn: NSRect(x: 9, y: 11, width: 92, height: 92))
            highlightBottomGradient20a.draw(in: oval2Path, angle: -90)
            
            
            //// Oval 3 Drawing
            let oval3Path = NSBezierPath(ovalIn: NSRect(x: 11, y: 13, width: 88, height: 88))
            color.setFill()
            oval3Path.fill()
            
            
            //// Bezier 2 Drawing
            NSGraphicsContext.saveGraphicsState()
            context.translateBy(x: 55, y: 57)
            context.rotate(by: angle)
            
            let bezier2Path = NSBezierPath()
            bezier2Path.move(to: NSPoint(x: 0, y: 4.05))
            bezier2Path.curve(to: NSPoint(x: -4.22, y: -0.12), controlPoint1: NSPoint(x: -2.33, y: 4.05), controlPoint2: NSPoint(x: -4.22, y: 2.19))
            bezier2Path.curve(to: NSPoint(x: 0, y: -4.29), controlPoint1: NSPoint(x: -4.22, y: -2.42), controlPoint2: NSPoint(x: -2.33, y: -4.29))
            bezier2Path.line(to: NSPoint(x: 0.06, y: -4.29))
            bezier2Path.curve(to: NSPoint(x: 4.22, y: -0.12), controlPoint1: NSPoint(x: 2.36, y: -4.26), controlPoint2: NSPoint(x: 4.22, y: -2.4))
            bezier2Path.curve(to: NSPoint(x: 0, y: 4.05), controlPoint1: NSPoint(x: 4.22, y: 2.19), controlPoint2: NSPoint(x: 2.33, y: 4.05))
            bezier2Path.close()
            bezier2Path.move(to: NSPoint(x: 2.87, y: 37.1))
            bezier2Path.curve(to: NSPoint(x: 9.33, y: 1.72), controlPoint1: NSPoint(x: 3.22, y: 35.68), controlPoint2: NSPoint(x: 9.33, y: 1.72))
            bezier2Path.curve(to: NSPoint(x: 0, y: -9.5), controlPoint1: NSPoint(x: 10.47, y: -4.59), controlPoint2: NSPoint(x: 5.7, y: -9.5))
            bezier2Path.curve(to: NSPoint(x: -9.33, y: 1.72), controlPoint1: NSPoint(x: -5.69, y: -9.5), controlPoint2: NSPoint(x: -10.47, y: -4.59))
            bezier2Path.curve(to: NSPoint(x: -2.87, y: 37.1), controlPoint1: NSPoint(x: -9.33, y: 1.72), controlPoint2: NSPoint(x: -3.06, y: 36.33))
            bezier2Path.curve(to: NSPoint(x: 0, y: 39.5), controlPoint1: NSPoint(x: -2.52, y: 38.52), controlPoint2: NSPoint(x: -1.47, y: 39.5))
            bezier2Path.curve(to: NSPoint(x: 2.87, y: 37.1), controlPoint1: NSPoint(x: 1.47, y: 39.5), controlPoint2: NSPoint(x: 2.52, y: 38.52))
            bezier2Path.close()
            NSGraphicsContext.saveGraphicsState()
            dialShadow.set()
            baseDial3.setFill()
            bezier2Path.fill()
            
            ////// Bezier 2 Inner Shadow
            NSGraphicsContext.saveGraphicsState()
            bezier2Path.bounds.clip()
            context.setShadow(offset: NSSize.zero, blur: 0, color: nil)
            
            context.setAlpha(dialInnerShadow.shadowColor!.alphaComponent)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            let bezier2OpaqueShadow = NSShadow()
            bezier2OpaqueShadow.shadowColor = dialInnerShadow.shadowColor!.withAlphaComponent(1)
            bezier2OpaqueShadow.shadowOffset = dialInnerShadow.shadowOffset
            bezier2OpaqueShadow.shadowBlurRadius = dialInnerShadow.shadowBlurRadius
            bezier2OpaqueShadow.set()
            
            context.setBlendMode(.sourceOut)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            
            bezier2OpaqueShadow.shadowColor!.setFill()
            bezier2Path.fill()
            
            context.endTransparencyLayer()
            context.endTransparencyLayer()
            NSGraphicsContext.restoreGraphicsState()
            
            NSGraphicsContext.restoreGraphicsState()
            
            baseDial4.setStroke()
            bezier2Path.lineWidth = 1
            bezier2Path.stroke()
            
            NSGraphicsContext.restoreGraphicsState()
            return true
        }
        
        return image
    }
}
