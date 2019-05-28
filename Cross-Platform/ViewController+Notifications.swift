//
//  ViewController+Notifications.swift
//  TickTask
//
//  Created by Joshua Grant on 5/27/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation
import UserNotifications

extension ViewController
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
    
    func createNotification()
    {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            // Register for push notifications
            //            DispatchQueue.main.async {
            //                NSApp.registerForRemoteNotifications()
            //            }
            
            self.scheduleNotification()
        }
    }

    func scheduleNotification()
    {
        let dateComponents = ViewController.fullDuration.dateComponents
        
        let notificationTitle = "timer_completed_title".localized
        let notificationBody = DateComponentsFormatter.completedDurationFormatter.string(from: dateComponents) ?? ""
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: ViewController.fullDuration,
                                                        repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
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
