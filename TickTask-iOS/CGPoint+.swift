//
//  CGPoint+.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/15/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation
import CoreGraphics

var defaultAngle = -CGFloat.pi * 2

var previousAngle: CGFloat = defaultAngle
var previousDistance: CGFloat = 0

var offset: Int = 0

extension CGPoint
{
    func distance(to point: CGPoint) -> CGFloat
    {
        let deltaX = point.x - self.x
        let deltaY = point.y - self.y
        
        return (deltaX.squared + deltaY.squared).squareRoot()
    }
    
    func angleFromPoint(point: CGPoint, snapTo snap: CGFloat) -> CGFloat
    {
        // We calculate the angle of the mouse location from the origin
        // Angle 0 is the right side of the unit circle
        var angle = atan2(self.y - point.y,  self.x - point.x)
        
        // Subtract pi/2 (90 degrees) to start the dial at the top
        angle += CGFloat.pi / 2.0
        
        // Because the angle is weird,,, i.e it is -4.712 *and* 1.570 at the left, and because the
        // top-left quadrant has positive numbers when everything else is negative, we do some adjustments to
        // make the top left quadrant compliant with everything else
        if angle > 0
        {
            angle = CGFloat.pi * -2.0 + angle
        }
        
        let distance = previousAngle.distance(to: angle)
//        let secondOrderDistance = previousDistance.distance(to: distance)
//        let sign = secondOrderDistance > 0 ? 1 : -1
        
//        previousDistance = distance
//
//        if abs(secondOrderDistance) > CGFloat.pi
//        {
//            offset += sign
//        }
        
//        print(secondOrderDistance, offset)
        
        // This distance isn't exact, but the difference between the angles can't be greater than 5 minutes..
        if abs(distance) > CGFloat.pi
        {
            angle = previousAngle
        }
        
        let finalAngle = angle.snap(to: snap)
        previousAngle = finalAngle
        
        return finalAngle
    }
    
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint
    {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}
