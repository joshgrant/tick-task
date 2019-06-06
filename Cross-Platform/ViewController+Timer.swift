////
////  ViewController+Timer.swift
////  TickTask
////
////  Created by Joshua Grant on 5/27/19.
////  Copyright © 2019 joshgrant. All rights reserved.
////
//
//import Foundation
//import CoreGraphics
//import UserNotifications
//
//extension ViewController
//{
//    static var timer: Timer?
//    static var start: Date?
//    static var fullDuration: TimeInterval = 0
//    static var maxMinutes: CGFloat = 60.0
//    static var numDivisions: Int = 12 // Corresponds to 5 minute intervals
//    static var lastAngle: CGFloat?
//    
//    static var countdownRemaining: TimeInterval {
//        get {
//            return (start != nil) ? Date().timeIntervalSince(start!) : TimeInterval.zero
//        }
//    }
//    
//    static var currentInterval: TimeInterval {
//        get {
//            return fullDuration - countdownRemaining
//        }
//    }
//    
//    func invalidateTimersAndDates()
//    {
//        ViewController.timer?.invalidate()
//        ViewController.timer = nil
//        ViewController.start = nil
//        
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//    }
//    
//    func initializeTimer() -> Timer
//    {
//        return Timer(timeInterval: 0.5,
//                     target: self,
//                     selector: #selector(timerUpdated(_:)),
//                     userInfo: nil,
//                     repeats: true)
//    }
//    
//    func setTimerToActive(interval: Double)
//    {
//        ViewController.fullDuration = interval
//        
//        guard ViewController.fullDuration > 0 else { return }
//        
//        ViewController.start = Date()
//        
//        ViewController.timer = initializeTimer()
//        RunLoop.main.add(ViewController.timer!, forMode: .common)
//        ViewController.timer?.fire()
//        
//        createNotification(at: ViewController.fullDuration)
//    }
//
//    @objc func timerUpdated(_ timer: Timer)
//    {
//        if ViewController.currentInterval <= 0
//        {
//            dial.state = .off
//            configureElements(interval: defaultInterval)
//            invalidateTimersAndDates()
//        }
//        else
//        {
//            configureElements()
//        }
//    }
//}
