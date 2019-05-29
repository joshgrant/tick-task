
//  NSView+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

extension NSView
{
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer?.cornerRadius ?? 0
        }
        set {
            self.wantsLayer = true
            layer?.cornerRadius = newValue
            layer?.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer?.borderWidth ?? 0
        }
        set {
            self.wantsLayer = true
            layer?.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: NSColor {
        get {
            return NSColor(cgColor: layer?.borderColor ?? CGColor.clear) ?? NSColor.clear
        }
        set {
            self.wantsLayer = true
            layer?.borderColor = newValue.cgColor
        }
    }
    
//    @IBInspectable var shadowColor: NSColor {
//        get {
//            return NSColor(cgColor: layer?.shadowColor ?? .clear) ?? .clear
//        }
//        set {
//            setShadowPath()
//            self.wantsLayer = true
//            layer?.shadowColor = newValue.cgColor
//        }
//    }
//    
//    @IBInspectable var shadowOffset: CGSize {
//        get {
//            return layer?.shadowOffset ?? CGSize.zero
//        }
//        set {
//            setShadowPath()
//            self.wantsLayer = true
//            layer?.shadowOffset = newValue
//        }
//    }
//    
//    @IBInspectable var shadowBlur: CGFloat {
//        get {
//            return layer?.shadowRadius ?? 0
//        }
//        set {
//            setShadowPath()
//            self.wantsLayer = true
//            layer?.shadowRadius = newValue
//        }
//    }
    
    func setShadowPath()
    {
//        if layer?.shadowPath == nil
//        {
            if let radius = layer?.cornerRadius, radius > 0
            {
                layer?.shadowPath = NSBezierPath(roundedRect: bounds, xRadius: radius, yRadius: radius).cgPath
            }
            else
            {
                layer?.shadowPath = NSBezierPath(rect: bounds).cgPath
            }
//        }
    }
    
    var renderImage: NSImage {
        let data = self.dataWithPDF(inside: self.frame)
        let image = NSImage(data: data)
        return image ?? NSImage()
    }
    
    var topLevelView: NSView
    {
        return self.superview?.topLevelView ?? self
    }
}
