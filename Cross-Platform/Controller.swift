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
    func configureElements(totalInterval: Double, rotations: Int, manual: Bool)
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
        
        delegate.configureElements(totalInterval: dial.totalInterval, rotations: dial.rotations, manual: true)
    }
    
    func dialUpdatedTracking(dial: Dial)
    {
        delegate.configureElements(totalInterval: dial.totalInterval, rotations: dial.rotations, manual: true)
    }
    
    func dialStoppedTracking(dial: Dial)
    {
        if dial.totalInterval == 0
        {
            dial.dialState = .inactive
            
            timerService.invalidateTimersAndDates()
            self.notificationService.removeNotification(with: Platform.current.alarmKey)
        }
        else
        {
            dial.dialState = .countdown
            
            ubiquitous.syncAlarm(timeInterval: dial.totalInterval,
                                 date: NSDate().addingTimeInterval(dial.totalInterval),
                                 on: Platform.current)
            
            let body = DateComponentsFormatter.completedDurationFormatter.string(from: dial.totalInterval.dateComponents) ?? ""
            
            notificationService.createNotification(timeInterval: dial.totalInterval,
                                                   body: body,
                                                   with: Platform.current.alarmKey)

            timerService.setTimerToActive(interval: dial.totalInterval) { (timer) in
                if self.timerService.currentInterval <= 0
                {
                    dial.dialState = .inactive
                    
                    self.delegate.configureElements(totalInterval: defaultInterval, rotations: dial.rotations, manual: true)
                }
                else
                {                    
                    let rotations = Int(self.timerService.currentInterval / 3600)
                    
                    self.delegate.configureElements(totalInterval: self.timerService.currentInterval,
                                                    rotations: rotations,
                                                    manual: false)
                }
            }
        }
        
        delegate.configureElements(totalInterval: dial.totalInterval, rotations: dial.rotations, manual: true)
    }
}
