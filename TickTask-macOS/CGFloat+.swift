//
//  CGFloat+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

extension CGFloat
{
    func toInterval(maxMinutes: CGFloat = 60) -> TimeInterval
    {
        // Start with the angle and convert it to a value from 0-1
        let normalized = self / (CGFloat.pi * 2) * -1
        
        // Then, interpolate that value between 0 and maxMinutes (60)
        let interpolated = normalized * maxMinutes
        
        // Then, convert the interpolated value to seconds
        let seconds = interpolated * 60
        
        // Then, remove noise
        let interval = ceil(seconds)
        
        return TimeInterval(interval)
    }
}
