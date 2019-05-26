//
//  Path.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

class Path
{
    #if os(iOS)
    var bezierPath: UIBezierPath
    #elseif os(OSX)
    var bezierPath: NSBezierPath
    #endif
    
    var bounds: CGRect {
        return bezierPath.bounds
    }
    
    var lineWidth: CGFloat {
        get {
            return bezierPath.lineWidth
        }
        set {
            bezierPath.lineWidth = newValue
        }
    }
    
    var cgPath: CGPath {
        get {
            return bezierPath.cgPath
        }
    }
    
    init()
    {
        #if os(iOS)
        self.bezierPath = UIBezierPath()
        #elseif os(OSX)
        self.bezierPath = NSBezierPath()
        #endif
    }
    
    init(ovalIn bounds: CGRect)
    {
        #if os(iOS)
        self.bezierPath = UIBezierPath(ovalIn: bounds)
        #elseif os(OSX)
        self.bezierPath = NSBezierPath(ovalIn: bounds)
        #endif
    }
    
    #if os(iOS)
    init(path: UIBezierPath)
    {
        self.bezierPath = path
    }
    #elseif os(OSX)
    init(path: NSBezierPath)
    {
        self.bezierPath = path
    }
    #endif
    
    func fill()
    {
        bezierPath.fill()
    }
    
    func stroke()
    {
        bezierPath.stroke()
    }
    
    func addClip()
    {
        bezierPath.addClip()
    }
    
    func move(to point: CGPoint)
    {
        bezierPath.move(to: point)
    }
    
    func addArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)
    {
        #if os(iOS)
        bezierPath.addArc(withCenter: center,
                          radius: radius,
                          startAngle: startAngle,
                          endAngle: endAngle,
                          clockwise: clockwise)
        #elseif os(OSX)
        bezierPath.appendArc(withCenter: center,
                             radius: radius,
                             startAngle: startAngle,
                             endAngle: endAngle,
                             clockwise: clockwise)
        #endif
    }
    
    func close()
    {
        bezierPath.close()
    }
}
