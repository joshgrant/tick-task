//
//  TimerService.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/6/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UserNotifications

class TimerService
{
    // MARK: Properties
    
    var fullDuration: TimeInterval = 0
    var maxMinutes: Float = 60.0
    var numDivisions: Int = 12 // 5 minute intervals
    
    var timer: Timer?
    var start: Date?
    
    init()
    {
        fullDuration = 0
        maxMinutes = 60.0
        numDivisions = 12
    }
    
    var countdownRemaining: TimeInterval {
        get {
            return (start != nil) ? Date().timeIntervalSince(start!) : TimeInterval.zero
        }
    }
    
    var currentInterval: TimeInterval {
        get {
            return fullDuration - countdownRemaining
        }
    }
    
    func invalidateTimersAndDates()
    {
        timer?.invalidate()
        timer = nil
        start = nil
    }
    
    func initializeTimer(action: @escaping (Timer) -> Void) -> Timer
    {
        return Timer(timeInterval: 1.0, repeats: true, block: action)
    }
    
    func setTimerToActive(interval: Double, update: @escaping (Timer) -> Void)
    {
        fullDuration = interval
        
        guard fullDuration > 0 else { return }
        
        start = Date()
        
        timer = initializeTimer(action: update)
        RunLoop.main.add(timer!, forMode: .common)
        timer?.fire()
    }
}
