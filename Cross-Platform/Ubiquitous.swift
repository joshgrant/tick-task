//
//  Ubiquitous.swift
//  TickTask
//
//  Created by Joshua Grant on 6/10/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

let keyChangedKey = "NSUbiquitousKeyValueStoreChangedKeysKey"

protocol UbiquitousDelegate
{
    func alarmWasRemotelyUpdated(platform: Platform, timeInterval: TimeInterval, date: Date)
}

class Ubiquitous
{
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
    
    func syncAlarm(timeInterval: TimeInterval, date: NSDate, on platform: Platform)
    {
        print("Time Interval: \(timeInterval), Date: \(date), Current Date: \(Date()) for: \(platform.rawValue)")
        
        NSUbiquitousKeyValueStore.default.set(["timeInterval" : timeInterval,
                                               "date" : date,],
                                              forKey: platform.rawValue)
    }
    
    @objc func keyStoreChanged(notification: NSNotification)
    {
        print("Notification: \(notification)")
        
        guard let delegate = delegate else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let keys = userInfo[keyChangedKey] as? NSArray else { return }
        
        for key in keys
        {
            if let key = key as? String,
                let platform = Platform(rawValue: key),
                let dictionary = NSUbiquitousKeyValueStore.default.dictionary(forKey: key),
                let date = dictionary["date"] as? Date,
                let timeInterval = dictionary["timeInterval"] as? TimeInterval
            {
                print("Updating")
                delegate.alarmWasRemotelyUpdated(platform: platform, timeInterval: timeInterval, date: date)
            }
            else
            {
                print("Fail: \(key)")
            }
        }
    }
}

