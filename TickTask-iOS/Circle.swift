//
//  Circle.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

class Circle: Shape
{
    private init(fill: Color?, gradient: Gradient?, shadow: Shadow?, border: Border?, ovalBounds: CGRect)
    {
        super.init(path: UIBezierPath(ovalIn: ovalBounds))
        
        if let fill = fill
        {
            self.fills = [fill]
        }
        
        if let gradient = gradient
        {
            self.gradients = [gradient]
        }
        
        if let shadow = shadow
        {
            self.shadows = [shadow]
        }
        
        if let border = border
        {
            self.borders = [border]
        }
    }
    
    convenience init(fill: Color, shadow: Shadow?, border: Border?, ovalBounds: CGRect)
    {
        self.init(fill: fill, gradient: nil, shadow: shadow, border: border, ovalBounds: ovalBounds)
    }
    
    convenience init(fill: Gradient, shadow: Shadow?, border: Border?, ovalBounds: CGRect)
    {
        self.init(fill: nil, gradient: fill, shadow: shadow, border: border, ovalBounds: ovalBounds)
    }
    
    // Utility method
    static func boundsWithLevel(level: Int,
                                frame: CGRect,
                                offset: CGSize,
                                borderWidth: CGFloat) -> CGRect
    {
        let origin = CGPoint(x: offset.width + borderWidth * CGFloat(level),
                             y: offset.height + borderWidth * CGFloat(level))
        
        return CGRect(origin: origin, size: CGSize(width: frame.size.width - origin.x * 2,
                                                   height: frame.size.height - origin.y * 2))
    }
}
