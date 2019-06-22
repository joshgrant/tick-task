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
    var record: CKRecord
    
    var alarmDate: Date {
        didSet {
            record["alarmDate"] = alarmDate
        }
    }
    
    var timeInterval: Double {
        didSet {
            record["timeInterval"] = timeInterval
        }
    }
    
    var platform: Platform {
        didSet {
            record["platform"] = platform.rawValue
        }
    }
    
    init(record: CKRecord)
    {
        self.alarmDate = record["alarmDate"] as? Date ?? Date()
        self.timeInterval = record["timeInterval"] as? Double ?? 0
        
        let recordPlatform = record["platform"] as? String ?? ""
        self.platform = Platform(rawValue: recordPlatform) ?? Platform.current
        
        self.record = record
    }
    
    convenience init(alarmDate: Date, timeInterval: Double, platform: Platform)
    {
        let recordID = CKRecord.ID.init(recordName: UUID().uuidString)
        let record = CKRecord(recordType: "Alarms", recordID: recordID)
        
        record["alarmDate"] = alarmDate
        record["timeInterval"] = timeInterval
        record["platform"] = platform.rawValue
        
        self.init(record: record)
    }
}
