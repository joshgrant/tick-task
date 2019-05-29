//
//  ViewController+Timer.swift
//  TickTask
//
//  Created by Joshua Grant on 5/27/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation
import CoreGraphics
import UserNotifications

extension ViewController
{
    static var timer: Timer?
    static var start: Date?
    static var fullDuration: TimeInterval = 0
    static var maxMinutes: CGFloat = 60.0
    static var numDivisions: Int = 12 // Corresponds to 5 minute intervals
    static var lastAngle: CGFloat?
    
    // This timer helps when the user drags out of the view (on mac)...
    static var inactivityTimer: Timer?
    
    static var countdownRemaining: TimeInterval {
        get {
            return (start != nil) ? Date().timeIntervalSince(start!) : TimeInterval.zero
        }
    }
    
    static var currentInterval: TimeInterval {
        get {
            return fullDuration - countdownRemaining
        }
    }
    
    func invalidateTimersAndDates()
    {
        ViewController.timer?.invalidate()
        ViewController.timer = nil
        ViewController.start = nil
        
        ViewController.inactivityTimer?.invalidate()
        ViewController.inactivityTimer = nil
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func initializeTimer() -> Timer
    {
        return Timer(timeInterval: 0.5,
                     target: self,
                     selector: #selector(timerUpdated(_:)),
                     userInfo: nil,
                     repeats: true)
    }
    
    func setTimerToActive(angle: CGFloat)
    {
        ViewController.fullDuration = angle.toInterval()
        
        guard ViewController.fullDuration > 0 else { return }
        
        configureInterfaceElements(state: .countdown, angle: angle)
        
        ViewController.start = Date()
        
        ViewController.timer = initializeTimer()
        RunLoop.main.add(ViewController.timer!, forMode: .common)
        ViewController.timer?.fire()
        
        createNotification()
    }
    
    func startInactivityTimer()
    {
        ViewController.inactivityTimer = Timer(timeInterval: 2.0, target: self, selector: #selector(inactivityTimerTriggered(timer:)), userInfo: nil, repeats: false)
        RunLoop.main.add(ViewController.inactivityTimer!, forMode: .common)
    }
    
    @objc func timerUpdated(_ timer: Timer)
    {
        configureInterfaceElements(state: .countdown)
        
        if ViewController.currentInterval <= 0
        {
            invalidateTimersAndDates()
            configureInterfaceElements(state: .inactive, angle: -CGFloat.pi * 2)
        }
    }
    
    @objc func inactivityTimerTriggered(timer: Timer)
    {
        if let angle = ViewController.lastAngle
        {
            userEndedDragging(angle: angle)
        }
    }
}
