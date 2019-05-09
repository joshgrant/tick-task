//
//  NSPoint+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

extension NSPoint
{
    func angleFromPoint(point: NSPoint) -> CGFloat
    {
        // We calculate the angle of the mouse location from the origin
        // Angle 0 is the right side of the unit circle
        var angle = atan2(self.y - point.y,  self.x - point.x)
        
        // Subtract pi/2 (90 degrees) to start the dial at the top
        angle -= CGFloat.pi / 2.0
        
        // Because the angle is weird,,, i.e it is -4.712 *and* 1.570 at the left, and because the
        // top-left quadrant has positive numbers when everything else is negative, we do some adjustments to
        // make the top left quadrant compliant with everything else
        if angle > 0
        {
            angle = CGFloat.pi * -2.0 + angle
        }
        
        return angle
    }
}
