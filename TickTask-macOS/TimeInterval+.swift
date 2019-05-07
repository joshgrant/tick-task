//
//  TimeInterval+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

extension TimeInterval
{
    var minutes: Int {
        get {
            return Int(floor(self / 60))
        }
    }
    
    var seconds: Int {
        get {
            return Int(self) % 60
        }
    }
    
    func toAngle(maxMinutes: CGFloat = 60) -> CGFloat
    {
        // Start with the number of seconds and convert it to minutes
        let minutes = CGFloat(self) / 60
        
        // Then, get a normalized value between 0 and 1
        let normalized = minutes / maxMinutes
        
        // Then, interpolate that value between 0 and 2 pi
        let angle = normalized * (CGFloat.pi * 2) * -1
        
        return angle
    }
}
