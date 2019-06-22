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
    var delegate: ControllerDelegate?
    
    var timerService: TimerService!
    var notificationService: NotificationService!
    var cloudService: CloudService!
    
    init(delegate: ControllerDelegate? = nil)
    {
        self.delegate = delegate
        
        timerService = TimerService()
        notificationService = NotificationService()
        cloudService = CloudService(delegate: self)
    }
}

extension Controller: CloudServiceDelegate
{
    func noAlarmsExistOnTheServer()
    {
        // This is just a little safe keeping to make sure
        // That we don't delete the device's alarm from the server (should never
        // be possible)
        let platforms = Platform.all.compactMap { (platform) -> Platform? in
            if platform == Platform.current
            {
                return nil
            }
            
            return platform
        }
        
        print("No alarms exist on the server: \(platforms)")
        
        for platform in platforms
        {
            notificationService.removeNotification(with: platform.rawValue)
        }
    }
    
    func alarmWasRemotelyUpdated(date: Date, timeInterval: TimeInterval, platform: Platform)
    {
        print("Platform: \(platform), timeInterval: \(timeInterval), date: \(date)")
        
        // The alarm time interval is the total time of the alarm
        // The alarm date lets us create a relative time interval
        // from when the device finished syncing.. for the notification
        
        if timeInterval > 0 && platform != .current
        {
            let body = DateComponentsFormatter.completedDurationFormatter.string(from: timeInterval.dateComponents) ?? ""
            
            notificationService.removeNotification(with: platform.rawValue)
            notificationService.createNotification(timeInterval: date.timeIntervalSinceNow,
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
        
        // Timer service delete
        timerService.invalidateTimersAndDates()
        
        // Notification service delete
        notificationService.removeNotification(with: Platform.current.rawValue)
        
        // Cloud service delete
        cloudService.deleteAlarm(platform: .current) {
            print("Deleted the alarm?")
        }
        
        delegate?.configureElements(dial: dial,
                                   totalInterval: dial.totalInterval,
                                   rotations: dial.rotations,
                                   manual: true)
    }
    
    func dialUpdatedTracking(dial: Dial)
    {
        delegate?.configureElements(dial: dial,
                                   totalInterval: dial.totalInterval,
                                   rotations: dial.rotations,
                                   manual: true)
    }
    
    func dialStoppedTracking(dial: Dial)
    {
        if dial.totalInterval == 0
        {
            dial.dialState = .inactive
            
            // Timer service delete
            timerService.invalidateTimersAndDates()
            
            // Notification service delete
            self.notificationService.removeNotification(with: Platform.current.rawValue)
            
            // Cloud service delete
            cloudService.deleteAlarm(platform: .current) {
                print("Deleted the alarm?")
            }
        }
        else
        {
            dial.dialState = .countdown
            
            // Cloud service add
            let alarm = Alarm(alarmDate: Date().addingTimeInterval(dial.totalInterval),
                              timeInterval: dial.totalInterval,
                              platform: Platform.current)
            cloudService.uploadAlarm(alarm: alarm)
            
            // Notification service add
            let body = DateComponentsFormatter.completedDurationFormatter.string(from: dial.totalInterval.dateComponents) ?? ""
            notificationService.createNotification(timeInterval: dial.totalInterval,
                                                   body: body,
                                                   with: Platform.current.rawValue)
            
            // Timer service add
            timerService.setTimerToActive(interval: dial.totalInterval) { (timer) in
                if self.timerService.currentInterval <= 0
                {
                    dial.dialState = .inactive
                    
                    self.delegate?.configureElements(dial: dial,
                                                    totalInterval: defaultInterval,
                                                    rotations: dial.rotations,
                                                    manual: true)
                }
                else
                {                    
                    let rotations = Int(self.timerService.currentInterval / 3600)
                    
                    self.delegate?.configureElements(dial: dial,
                                                    totalInterval: self.timerService.currentInterval,
                                                    rotations: rotations,
                                                    manual: false)
                }
            }
        }
        
        delegate?.configureElements(dial: dial,
                                   totalInterval: dial.totalInterval,
                                   rotations: dial.rotations,
                                   manual: true)
    }
}
