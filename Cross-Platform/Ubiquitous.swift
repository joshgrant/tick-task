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
        NSUbiquitousKeyValueStore.default.set(["timeInterval" : timeInterval,
                                               "date" : date,],
                                              forKey: platform.alarmKey)
    }
    
    @objc func keyStoreChanged(notification: NSNotification)
    {
        guard let userInfo = notification.userInfo else { return }
        guard let key = userInfo[keyChangedKey] as? NSArray else { return }
        guard let value = key.firstObject as? String else { return }
        guard let dictionary = NSUbiquitousKeyValueStore.default.dictionary(forKey: value) else { return }
        guard let date = dictionary["date"] as? Date else { return }
        guard let timeInterval = dictionary["timeInterval"] as? TimeInterval else { return }
        guard let delegate = delegate else { return }
        
        delegate.alarmWasRemotelyUpdated(platform: platform, timeInterval: timeInterval, date: date)
    }
}

