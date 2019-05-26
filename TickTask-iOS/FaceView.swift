//
//  FaceView.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

@IBDesignable class FaceView: UIView
{
    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()!
        let drawingData = DrawingData(rect: rect)
        
        let faceBackgroundCircle = Circle(fill: Color.faceFill,
                                          shadow: Shadow.faceDropShadow(with: drawingData.scaleFactor),
                                          border: nil,
                                          ovalBounds: Circle.boundsWithLevel(level: 0,
                                                                             frame: frame,
                                                                             offset: drawingData.padding,
                                                                             borderWidth: drawingData.rimThickness))
        
        faceBackgroundCircle.draw(context: context)
        
        let outerRimCircle = Circle(fill: Gradient.outerRimGradient,
                                    shadow: nil,
                                    border: Border.faceOuterBorder(with: drawingData.scaleFactor),
                                    ovalBounds: Circle.boundsWithLevel(level: 0,
                                                                       frame: frame,
                                                                       offset: drawingData.padding,
                                                                       borderWidth: drawingData.rimThickness))
        
        outerRimCircle.draw(context: context)
        
        let centerRimCircle = Circle(fill: Color.faceFill,
                                     shadow: nil,
                                     border: nil,
                                     ovalBounds: Circle.boundsWithLevel(level: 1,
                                                                        frame: frame,
                                                                        offset: drawingData.padding,
                                                                        borderWidth: drawingData.rimThickness))
        
        centerRimCircle.draw(context: context)
        
        let innerRimCircle = Circle(fill: Gradient.innerRimGradient,
                                    shadow: nil,
                                    border: nil,
                                    ovalBounds: Circle.boundsWithLevel(level: 2,
                                                                       frame: frame,
                                                                       offset: drawingData.padding,
                                                                       borderWidth: drawingData.rimThickness))
        
        innerRimCircle.draw(context: context)
        
        let faceInnerCircle = Circle(fill: Color.faceFill,
                                     shadow: nil,
                                     border: nil,
                                     ovalBounds: Circle.boundsWithLevel(level: 3,
                                                                        frame: frame,
                                                                        offset: drawingData.padding,
                                                                        borderWidth: drawingData.rimThickness))
        
        faceInnerCircle.draw(context: context)
    }
}

