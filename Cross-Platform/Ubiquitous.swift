//
//  Ubiquitous.swift
//  TickTask
//
//  Created by Joshua Grant on 6/10/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

enum Platform
{
    case iOS
    case OSX
}

protocol UbiquitousDelegate
{
    func alarmWasRemotelyUpdated(platform: Platform, date: Date)
}

class Ubiquitous
{
    struct Key
    {
        static var alarmDateiOS = "me.joshgrant.TickTask.iOS.alarmDate"
        static var alarmDateOSX = "me.joshgrant.TickTask.OSX.alarmDate"
        static var keyChanged = "NSUbiquitousKeyValueStoreChangedKeysKey"
        
        // There is a better way to do this...
//        // Maybe this could conform to some protocol?
//        static func keyForString(string: String) -> String
//        {
//            switch string
//            {
//            case "me.joshgrant.TickTask.iOS.alarmDate":
//                return alarmDateiOS
//            default:
//                return alarmDateiOS
//            }
//        }
//        
//        static func platformForKey(key: String) -> Platform
//        {
//            switch key
//            {
//            case alarmDateiOS: return .iOS
//            case alarmDateOSX: return .OSX
//                
//            }
//        }
    }
    
    var delegate: UbiquitousDelegate?
    var platform: Platform
    
    init(delegate: UbiquitousDelegate, platform: Platform)
    {
        self.delegate = delegate
        self.platform = platform
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyStoreChanged(notification:)),
                                               name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object: NSUbiquitousKeyValueStore.default)
        
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    static func syncAlarm(interval: Double, on platform: Platform)
    {
        switch platform
        {
        case .iOS:
            NSUbiquitousKeyValueStore.default.set(NSDate().addingTimeInterval(interval),
                                                  forKey: Key.alarmDateiOS)
        case .OSX:
            NSUbiquitousKeyValueStore.default.set(NSDate().addingTimeInterval(interval),
                                                  forKey: Key.alarmDateOSX)
        }
    }
    
    @objc func keyStoreChanged(notification: NSNotification)
    {
        if let userInfo = notification.userInfo, let key = userInfo[Key.keyChanged] as? NSArray, let value = key.firstObject as? String
        {
            if let date = NSUbiquitousKeyValueStore.default.object(forKey: value) as? Date
            {
                print(date)
                
                if let delegate = delegate
                {
                    delegate.alarmWasRemotelyUpdated(platform: platform, date: date)
                }
            }
        }
    }
}
