//
//  TimeInterval+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation
import CoreGraphics

// I'm using this time interval as minutes, not seconds....

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
    
    var durationString: String {
        return DateComponentsFormatter.currentDurationFormatter.string(from: dateComponents) ?? ""
    }
    
    var dateComponents: DateComponents
    {
        return DateComponents(minute: minutes, second: seconds)
    }
    
    func toAngle(maxMinutes: Double = 60) -> Double
    {
        // Start with the number of seconds and convert it to minutes
        let minutes = Double(self) / 60
        
        // Then, get a normalized value between 0 and 1
        let normalized = 1.0 - (minutes / maxMinutes)
        
        // Then, interpolate that value between 0 and 2 pi
        // Then, multiply it by negative one, because we want the dial to rotate to the right
        // instead of the left
        let angle = normalized * -Double.pi * 2
        
        return Double.minimum(angle, 0)
    }
    
    func toSeconds(maxMinutes: Double = 60) -> Double
    {
        let normalized = 1.0 - (self / (Double.pi * 2) * -1)
        
        // Then, interpolate that value between 0 and maxMinutes (60)
        let interpolated = normalized * maxMinutes
        
        let seconds = interpolated * 60
        
        let interval = seconds.rounded()
        
        return Double(interval)
    }
    
    func snap(to snap: Double) -> Double
    {
        // Now we want to make sure the dial "snaps" to different locations.
        // This is achieved by subtracting the remainder from the value
        // This gives us twice the number of snaps (because a full rotation is 2 pi)
        let remainder = self.remainder(dividingBy: Double((CGFloat.pi * 2)) / snap)
        return self - remainder
    }
}
