//
//  CGPoint+.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

extension CGPoint
{
    func angleFromPoint(point: CGPoint, snap: CGFloat = 12) -> CGFloat
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
        
        // Now we want to make sure the dial "snaps" to different locations.
        // This is achieved by subtracting the remainder from the value
        // This gives us twice the number of snaps (because a full rotation is 2 pi)
        let remainder = angle.remainder(dividingBy: (CGFloat.pi * 2) / snap)
        
        angle -= remainder
        
        return angle
    }
}
