//
//  TimeInterval+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation
import CoreGraphics

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
        #if os(iOS)
        // Account for the flipped coordinate system on iOS
        let normalized = 1.0 - (minutes / maxMinutes)
        #elseif os(OSX)
        let normalized = minutes / maxMinutes
        #endif
        
        // Then, interpolate that value between 0 and 2 pi
        // Then, multiply it by negative one, because we want the dial to rotate to the right
        // instead of the left
        let angle = normalized * (CGFloat.pi * 2) * -1
        
        return CGFloat.minimum(angle, 0)
    }
}
