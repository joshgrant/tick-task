//
//  NotificationService.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/6/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UserNotifications

class NotificationService
{
    func requestAuthorizationToDisplayNotifications()
    {
        let center = UNUserNotificationCenter.current()
        
        var options: UNAuthorizationOptions
        
        #if os(iOS)
        if #available(iOS 12.0, *)
        {
            options = [.alert, .sound, .criticalAlert, .badge]
        } else {
            // Fallback on earlier versions
            options = [.alert, .sound, .badge]
        }
        center.delegate = self
        #elseif os(OSX)
        options = [.alert, .sound, .criticalAlert, .badge]
        #endif
        
        center.requestAuthorization(options: options) { (granted, error) in
            guard granted else { return }
        }
    }
    
    func createNotification(at timeInterval: TimeInterval)
    {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            // Register for push notifications
            //            DispatchQueue.main.async {
            //                NSApp.registerForRemoteNotifications()
            //            }
            
            self.scheduleNotification(at: timeInterval)
        }
    }
    
    func scheduleNotification(at timeInterval: TimeInterval)
    {
        let dateComponents = timeInterval.dateComponents
        
        let notificationTitle = "timer_completed_title".localized
        let notificationBody = DateComponentsFormatter.completedDurationFormatter.string(from: dateComponents) ?? ""
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationIdentifier,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error
            {
                debugPrint("Error adding the notification: \(error)")
            }
        }
    }

}
