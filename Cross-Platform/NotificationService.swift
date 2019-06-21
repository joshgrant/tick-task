//
//  NotificationService.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/6/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

// If the user wants to have alerts - then they have to specify it in the system preferences
// They need to change it from banner to alert...

import UserNotifications

struct NotificationIdentifier
{
    static var iOS = "me.joshgrant.TickTask.iOS.TimeUpNotification"
    static var iOSDebug = "me.joshgrant.TickTask.iOS.Debug.TimeUpNotification"
    static var OSX = "me.joshgrant.TickTask.OSX.TimeUpNotification"
    static var OSXDebug = "me.joshgrant.TickTask.OSX.Debug.TimeUpNotification"
    
    static var currentIdentifier: String {
        #if os(iOS)
        #if DEBUG
        return iOSDebug
        #else
        return iOS
        #endif
        #elseif os(OSX)
        #if DEBUG
        return OSXDebug
        #else
        return OSX
        #endif
        #endif
    }
}

class NotificationService: NSObject
{
    override init()
    {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorizationToDisplayNotifications()
    {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        center.requestAuthorization(options: options) { (granted, error) in
            guard granted else { return }
        }
    }
    
    func createNotification(timeInterval: TimeInterval, body: String, with key: String)
    {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            let dateComponents = Date().addingTimeInterval(timeInterval).components
            
            // Perhaps we could allow people to repeat their alerts...
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let title = "timer_completed_title".localized
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: key,
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
    
    func removeAllNotifications()
    {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func removeNotification(with identifier: String)
    {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

extension NotificationService: UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
