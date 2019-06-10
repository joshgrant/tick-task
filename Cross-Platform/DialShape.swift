//
//  DialShape.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

class DialShape: Shape
{
    init(drawingData: DrawingData)
    {
        super.init(path: DialShape.dialPath(drawingData: drawingData))
        
        self.frame = drawingData.rect
        
        self.shadows = [
            Shadow.dialOuterStrokeShadow(with: drawingData.scaleFactor),
            Shadow.dialOuterDropShadow(with: drawingData.scaleFactor),
            Shadow.dialInnerShadow(with: drawingData.scaleFactor),
            Shadow.dialInnerHighlight(with: drawingData.scaleFactor)
        ]
        
        self.fills = [
            Color.dialFillInactive
        ]
        
        self.borders = [
            Border.dialInnerBorder(with: drawingData.scaleFactor),
            Border.dialOuterBorder(with: drawingData.scaleFactor)
        ]
    }
    
    func draw(context: CGContext, angle: CGFloat, state: DialState)
    {
        switch state {
        case .selected:
            self.fills = [Color.dialFillSelected]
        case .inactive:
            self.fills = [Color.dialFillInactive]
        case .countdown:
            self.fills = [Color.dialFillCountdown]
        }
        
        context.pushPop {
            if let frame = frame
            {
                context.translateBy(x: frame.size.width / 2,
                                    y: frame.size.height / 2)
            }
            context.rotate(by: angle)
            drawOuterShadows(context: context)
            drawGradients(context: context)
            drawFills(context: context)
            drawInnerShadows(context: context)
            drawBorders(context: context)
        }
    }
    
    static func dialPath(drawingData: DrawingData, withCenter: Bool = true) -> Path
    {
        let dialLength = 32 * drawingData.scaleFactor
        let bodyRadius = 8.205 * drawingData.scaleFactor
        let tipRadius = 2.35 * drawingData.scaleFactor
        let innerCircleRadius = 3.69 * drawingData.scaleFactor
        
        let bodyCenter = CGPoint(x: 0, y: 0)
        let tipCenter = CGPoint(x: bodyCenter.x, y: bodyCenter.y - dialLength)
        
        let distanceCenters = bodyCenter.distance(to: tipCenter)
        let differenceRadius = bodyRadius - tipRadius
        
        // We use the pythagorean theorem to find the third side of a right triangle
        // a^2 + b^2 = c^2
        // In this case, we have a^2 and c^2 but not b^2
        let distanceTangents = (distanceCenters.squared - differenceRadius.squared).squareRoot()
        
        // Now we use the law of sines to find the angle that the tangent is from the center of the circle
        let theta = asin(distanceTangents / distanceCenters)
        
        // We have to get the angle that is 90° - theta. This is the angle we can use to calculate the side lengths
        let thetaComplement = (CGFloat.pi / 2) - theta
        
        // The right tangent on the body circle is where we'll start drawing
        let bodyRight = CGPoint(x: bodyCenter.x + bodyRadius * cos(thetaComplement),
                                y: bodyCenter.y - bodyRadius * sin(thetaComplement))
        
        let path = Path()
        
        #if os(iOS)
        let clockwise = false
        #elseif os(OSX)
        path.windingRule = .evenOdd
        let clockwise = true
        #endif
        
        if withCenter
        {
            path.addArc(center: bodyCenter,
                        radius: innerCircleRadius,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: clockwise)
            
            path.close()
        }
        
        path.move(to: bodyRight)
        
        path.addArc(center: bodyCenter,
                    radius: bodyRadius,
                    startAngle: -thetaComplement,
                    endAngle: CGFloat.pi + thetaComplement,
                    clockwise: true)
        path.addArc(center: tipCenter,
                    radius: tipRadius,
                    startAngle: CGFloat.pi + thetaComplement,
                    endAngle: -thetaComplement,
                    clockwise: true)
        
        path.close()
        
        return path
    }
}
