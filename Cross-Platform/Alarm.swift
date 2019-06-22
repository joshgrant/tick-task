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
    var record: CKRecord?
    
    var alarmDate: Date? {
        didSet {
            record!["alarmDate"] = alarmDate
        }
    }
    
    var timeInterval: Double? {
        didSet {
            record!["timeInterval"] = timeInterval
        }
    }
    
    var platform: Platform? {
        didSet {
            record!["platform"] = platform?.rawValue
        }
    }
    
    init(record: CKRecord)
    {
        self.record = record
        self.alarmDate = self.record!["alarmDate"] as? Date
        self.timeInterval = self.record!["timeInterval"] as? Double
        self.platform = Platform(rawValue: (self.record!["platform"] as? String ?? ""))
    }
    
    convenience init(alarmDate: Date, timeInterval: Double, platform: Platform)
    {
        let record = CKRecord(recordType: "Alarms", recordID: CKRecord.ID.init(recordName: UUID().uuidString))
        record["alarmDate"] = alarmDate
        record["timeInterval"] = timeInterval
        record["platform"] = platform.rawValue
        
        self.init(record: record)
    }
}
