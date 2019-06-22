//
//  Controller.swift
//  TickTask
//
//  Created by Joshua Grant on 6/11/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation
import CloudKit

// Controller is an abstraction of all of the business logic that exists
// between the iOS and the OSX version of the app

protocol ControllerDelegate
{
    func configureElements(dial: Dial?, totalInterval: Double, rotations: Int, manual: Bool)
}

class Controller
{
    var delegate: ControllerDelegate
    
    var timerService: TimerService!
    var notificationService: NotificationService!
//    var ubiquitous: Ubiquitous!
    var cloudService: CloudService!
    
    var alarms: [Alarm] = []
    
    init(delegate: ControllerDelegate)
    {
        self.delegate = delegate
        
        timerService = TimerService()
        notificationService = NotificationService()
        cloudService = CloudService()
        
        notificationService.requestAuthorizationToDisplayNotifications()
    }
}

extension Controller: UbiquitousDelegate
{
    func alarmWasRemotelyUpdated(platform: Platform, timeInterval: TimeInterval, date: Date)
    {
        let relativeTimeInterval = date.timeIntervalSinceNow
        
        print("Platform: \(platform), timeInterval: \(timeInterval), date: \(date)")
        
        if timeInterval > 0 && platform != .current
        {
            let body = DateComponentsFormatter.completedDurationFormatter.string(from: timeInterval.dateComponents) ?? ""
            
            notificationService.removeNotification(with: platform.rawValue)
            notificationService.createNotification(timeInterval: relativeTimeInterval,
                                                   body: body,
                                                   with: platform.rawValue)
        }
    }
}

extension Controller: DialDelegate
{
    func dialStartedTracking(dial: Dial)
    {
        dial.dialState = .selected
        
        timerService.invalidateTimersAndDates()
        notificationService.removeNotification(with: Platform.current.rawValue)
        
        delegate.configureElements(dial: dial,
                                   totalInterval: dial.totalInterval,
                                   rotations: dial.rotations,
                                   manual: true)
    }
    
    func dialUpdatedTracking(dial: Dial)
    {
        delegate.configureElements(dial: dial,
                                   totalInterval: dial.totalInterval,
                                   rotations: dial.rotations,
                                   manual: true)
    }
    
    func dialStoppedTracking(dial: Dial)
    {
        if dial.totalInterval == 0
        {
            dial.dialState = .inactive
            
            timerService.invalidateTimersAndDates()
            self.notificationService.removeNotification(with: Platform.current.rawValue)
        }
        else
        {
            dial.dialState = .countdown
            
            let alarm = Alarm(alarmDate: Date().addingTimeInterval(dial.totalInterval),
                              timeInterval: dial.totalInterval,
                              platform: Platform.current)
            
            cloudService.uploadAlarm(alarm: alarm)
            
            let body = DateComponentsFormatter.completedDurationFormatter.string(from: dial.totalInterval.dateComponents) ?? ""
            
            notificationService.createNotification(timeInterval: dial.totalInterval,
                                                   body: body,
                                                   with: Platform.current.rawValue)

            timerService.setTimerToActive(interval: dial.totalInterval) { (timer) in
                if self.timerService.currentInterval <= 0
                {
                    dial.dialState = .inactive
                    
                    self.delegate.configureElements(dial: dial,
                                                    totalInterval: defaultInterval,
                                                    rotations: dial.rotations,
                                                    manual: true)
                }
                else
                {                    
                    let rotations = Int(self.timerService.currentInterval / 3600)
                    
                    self.delegate.configureElements(dial: dial,
                                                    totalInterval: self.timerService.currentInterval,
                                                    rotations: rotations,
                                                    manual: false)
                }
            }
        }
        
        delegate.configureElements(dial: dial,
                                   totalInterval: dial.totalInterval,
                                   rotations: dial.rotations,
                                   manual: true)
    }
}
