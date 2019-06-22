//
//  Alarm.swift
//  TickTask
//
//  Created by Joshua Grant on 6/21/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation
import CloudKit

class Alarm: NSObject
{
    // MARK: - Properties
    
    var record: CKRecord
    
    var alarmDate: Date? {
        get {
            return record["alarmDate"] as? Date
        }
        set {
            record["alarmDate"] = newValue
        }
    }
    
    var timeInterval: Double? {
        get {
            return record["timeInterval"] as? Double
        }
        set {
            record["timeInterval"] = newValue
        }
    }
    
    var platform: Platform? {
        get {
            let recordPlatform = record["platform"] as? String ?? ""
            return Platform(rawValue: recordPlatform)
        }
        set {
            record["platform"] = newValue?.rawValue
        }
    }
    
    // MARK: - Initialization
    
    init(record: CKRecord)
    {
        self.record = record
    }
    
    convenience init(alarmDate: Date, timeInterval: Double, platform: Platform)
    {
        let recordID = CKRecord.ID.init(recordName: UUID().uuidString)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        self.init(record: record)
        
        self.alarmDate = alarmDate
        self.timeInterval = timeInterval
        self.platform = platform
    }
}
