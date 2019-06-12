//
//  Circle.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreGraphics

class Circle: Shape
{
    private init(fill: Color?, gradient: Gradient?, shadow: Shadow?, border: Border?, ovalBounds: CGRect)
    {
        super.init(path: Path(ovalIn: ovalBounds))
        
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
                                borderWidth: CGFloat,
                                scaleFactor: CGFloat) -> CGRect
    {
        let origin = CGPoint(x: offset.width + borderWidth * CGFloat(level),
                             y: offset.height + borderWidth * CGFloat(level))
        
        return CGRect(origin: origin, size: CGSize(width: frame.size.width - origin.x * 2,//- 6 * scaleFactor,
                                                   height: frame.size.height - origin.y * 2))// - 6 * scaleFactor))
    }
    
    // MARK: Global Instances
    
    static func faceBackgroundCircle(with drawingData: DrawingData) -> Circle
    {
        return Circle(fill: Color.faceFill,
               shadow: Shadow.faceDropShadow(with: drawingData.scaleFactor),
               border: nil,
               ovalBounds: Circle.boundsWithLevel(level: 0,
                                                  frame: drawingData.rect,
                                                  offset: drawingData.padding,
                                                  borderWidth: drawingData.rimThickness,
                                                  scaleFactor: drawingData.scaleFactor))
    }
    
    static func outerRimCircle(with drawingData: DrawingData) -> Circle
    {
        return Circle(fill: Gradient.outerRimGradient,
                      shadow: nil,
                      border: Border.faceOuterBorder(with: drawingData.scaleFactor),
                      ovalBounds: Circle.boundsWithLevel(level: 0,
                                                         frame: drawingData.rect,
                                                         offset: drawingData.padding,
                                                         borderWidth: drawingData.rimThickness,
                                                         scaleFactor: drawingData.scaleFactor))
    }
    
    static func centerRimCircle(with drawingData: DrawingData) -> Circle
    {
        return Circle(fill: Color.faceFill,
               shadow: nil,
               border: nil,
               ovalBounds: Circle.boundsWithLevel(level: 1,
                                                  frame: drawingData.rect,
                                                  offset: drawingData.padding,
                                                  borderWidth: drawingData.rimThickness,
                                                  scaleFactor: drawingData.scaleFactor))
    }
    
    static func innerRimCircle(with drawingData: DrawingData) -> Circle
    {
        return Circle(fill: Gradient.innerRimGradient,
                      shadow: nil,
                      border: nil,
                      ovalBounds: Circle.boundsWithLevel(level: 2,
                                                         frame: drawingData.rect,
                                                         offset: drawingData.padding,
                                                         borderWidth: drawingData.rimThickness,
                                                         scaleFactor: drawingData.scaleFactor))
    }
    
    static func faceInnerCircle(with drawingData: DrawingData) -> Circle
    {
        return Circle(fill: Color.faceFill,
               shadow: nil,
               border: nil,
               ovalBounds: Circle.boundsWithLevel(level: 3,
                                                  frame: drawingData.rect,
                                                  offset: drawingData.padding,
                                                  borderWidth: drawingData.rimThickness,
                                                  scaleFactor: drawingData.scaleFactor))
    }
}
