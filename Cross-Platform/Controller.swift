//
//  Controller.swift
//  TickTask
//
//  Created by Joshua Grant on 6/11/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

protocol ControllerDelegate
{
    func configureElements(interval: Double, manual: Bool)
}

class Controller
{
    var delegate: ControllerDelegate
    
    var timerService: TimerService!
    var notificationService: NotificationService!
    var ubiquitous: Ubiquitous!
    
    init(delegate: ControllerDelegate)
    {
        self.delegate = delegate
        
        timerService = TimerService()
        notificationService = NotificationService()
        ubiquitous = Ubiquitous(delegate: self, platform: Platform.current)
    }
}

extension Controller: UbiquitousDelegate
{
    func alarmWasRemotelyUpdated(platform: Platform, timeInterval: TimeInterval, date: Date)
    {
        let relativeTimeInterval = date.timeIntervalSinceNow
        
        // This whole thing isn't very clear
        if timeInterval > 0
        {
            let body = DateComponentsFormatter.completedDurationFormatter.string(from: timeInterval.dateComponents) ?? ""
            
            notificationService.removeNotification(with: platform.alarmKey)
            notificationService.createNotification(timeInterval: relativeTimeInterval,
                                                   body: body,
                                                   with: platform.alarmKey)
        }
    }
}

extension Controller: DialDelegate
{
    func dialStartedTracking(dial: Dial)
    {
        dial.dialState = .selected
        
        timerService.invalidateTimersAndDates()
        notificationService.removeNotification(with: Platform.current.alarmKey)
        
        delegate.configureElements(interval: dial.doubleValue, manual: true)
    }
    
    func dialUpdatedTracking(dial: Dial)
    {
        delegate.configureElements(interval: dial.doubleValue, manual: true)
    }
    
    func dialStoppedTracking(dial: Dial)
    {
        if dial.doubleValue == 0
        {
            dial.dialState = .inactive
            
            timerService.invalidateTimersAndDates()
            self.notificationService.removeNotification(with: Platform.current.alarmKey)
        }
        else
        {
            dial.dialState = .countdown
            
            ubiquitous.syncAlarm(timeInterval: dial.doubleValue,
                                 date: NSDate().addingTimeInterval(dial.doubleValue),
                                 on: Platform.current)
            
            let body = DateComponentsFormatter.completedDurationFormatter.string(from: dial.doubleValue.dateComponents) ?? ""
            
            notificationService.createNotification(timeInterval: dial.doubleValue,
                                                   body: body,
                                                   with: Platform.current.alarmKey)

            timerService.setTimerToActive(interval: dial.doubleValue) { (timer) in
                if self.timerService.currentInterval <= 0
                {
                    dial.dialState = .inactive
                    
                    self.delegate.configureElements(interval: defaultInterval, manual: true)
                }
                else
                {
                    self.delegate.configureElements(interval: self.timerService.currentInterval, manual: false)
                }
            }
        }
        
        delegate.configureElements(interval: dial.doubleValue, manual: true)
    }
}
