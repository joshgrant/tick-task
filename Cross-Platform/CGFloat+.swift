//
//  CGFloat+.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/15/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat
{
    var squared: CGFloat
    {
        return self * self
    }
    
    func toInterval(maxMinutes: CGFloat = 60) -> TimeInterval
    {   
        // Start with the angle and convert it to a value from 0-1
        // Because we're rotating the dial to the right instead of the left
        // The angles are different than the unit circle's

        let normalized = 1.0 - (self / (CGFloat.pi * 2) * -1)
        
        // Then, interpolate that value between 0 and maxMinutes (60)
        let interpolated = normalized * maxMinutes
        
        // Then, convert the interpolated value to seconds
        let seconds = interpolated * 60
        

        let interval = seconds.rounded()

        
        return TimeInterval(interval)
    }
    
    func snap(to snap: CGFloat) -> CGFloat
    {
        // Now we want to make sure the dial "snaps" to different locations.
        // This is achieved by subtracting the remainder from the value
        // This gives us twice the number of snaps (because a full rotation is 2 pi)
        let remainder = self.remainder(dividingBy: (CGFloat.pi * 2) / snap)
        return self - remainder
    }
}
