//
//  TimeInterval.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/15/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

extension TimeInterval
{
    var minutes: Int {
        get {
            if self >= 0
            {
                return Int(floor(self / 60))
            }
            else
            {
                return Int(ceil(self / 60))
            }
        }
    }
    
    var seconds: Int {
        get {
            return Int(self) % 60
        }
    }
    
    var dateComponents: DateComponents
    {
        return DateComponents(minute: minutes, second: seconds)
    }
    
    func toAngle(maxMinutes: CGFloat = 60) -> CGFloat
    {
        // Start with the number of seconds and convert it to minutes
        let minutes = CGFloat(self) / 60
        
        // Then, get a normalized value between 0 and 1
        // Also, account for the flipped iOS coordinate system
        let normalized = 1.0 - (minutes / maxMinutes)
        
        print(normalized)
        
        // Then, interpolate that value between 0 and 2 pi
        // Then, multiply it by negative one, because we want the dial to rotate to the right
        // instead of the left
        let angle = normalized * (CGFloat.pi * 2) * -1
        
        // We have to adjust for iOS's flipped coordinate system
        // Maybe we can simplify the maths
//        let adjusted = CGFloat.pi * 2 - angle
        
//        print("Adjusted", adjusted)
        
        return CGFloat.minimum(angle, 0)
    }
}
