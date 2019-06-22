//
//  CloudService.swift
//  TickTask
//
//  Created by Joshua Grant on 6/21/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CloudKit

let subscriptionIdentifier = "me.joshgrant.TickTask.alarmChange"
let containerIdentifier = "iCloud.me.joshgrant.TickTask"
let recordType = "Alarms"

protocol CloudServiceDelegate
{
    func alarmsWereUpdated(alarms: [Platform: Alarm?])
}

class CloudService
{
    // MARK: - Properties
    
    var container: CKContainer
    var database: CKDatabase
    var containerID: String
    
    var delegate: CloudServiceDelegate
    
    init(delegate: CloudServiceDelegate)
    {
        self.container = CKContainer(identifier: containerIdentifier)
        self.database = container.database(with: .private)
        self.containerID = container.containerIdentifier ?? ""
        
        self.delegate = delegate
        
        downloadAlarms()
    }
    
    // MARK: - Subscriptions
    
    /*
     Truth be told, I'm not sure when this method is supposed to be called.
     I'm calling it on app start, but that might not make any sense...
     */
    func createSubscription()
    {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: recordType,
                                               predicate: predicate,
                                               subscriptionID: subscriptionIdentifier,
                                               options: [CKQuerySubscription.Options.firesOnRecordCreation,
                                                         CKQuerySubscription.Options.firesOnRecordDeletion,
                                                         CKQuerySubscription.Options.firesOnRecordUpdate])
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        subscription.notificationInfo = notificationInfo
        
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription],
                                                       subscriptionIDsToDelete: [])
        
        operation.modifySubscriptionsCompletionBlock = { (_, _, error) in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                print("Added the subscription")
            }
        }
        
        database.add(operation)
    }
    
    // MARK: - CRUD Operations
    
    // Download alarms simply gets the alarms that are on the server and
    // Synchronizes them with the alarms that are on the device...
    func downloadAlarms()
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else if let alarmRecords = records
            {
                print("Downloaded \(alarmRecords.count) alarm(s)."
                
                var alarms: [Platform: Alarm?] = [
                    .OSX: nil,
                    .OSXDebug: nil,
                    .iOS: nil,
                    .iOSDebug: nil
                ]
                
                for alarmRecord in alarmRecords
                {
                    let alarm = Alarm(record: alarmRecord)
                    alarms[alarm.platform] = alarm
                }
                
                self.delegate.alarmsWereUpdated(alarms: alarms)
            }
            else
            {
                print("No Records")
            }
        }
    }
    
    func uploadAlarm(alarm: Alarm)
    {
        let predicate = NSPredicate(format: "platform == %@", alarm.platform.rawValue)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if records?.count == 0
            {
                self.database.save(alarm.record, completionHandler: { (record, error) in
                    if let error = error
                    {
                        print(error.localizedDescription)
                    }
                    else
                    {
                        print("Uploaded an alarm")
                    }
                })
            }
            else if let record = records?.first
            {
                let updateAlarm = Alarm(record: record)
                updateAlarm.alarmDate = alarm.alarmDate
                updateAlarm.timeInterval = alarm.timeInterval
                
                let modifyRecordOperation = CKModifyRecordsOperation(recordsToSave: [updateAlarm.record],
                                                                     recordIDsToDelete: [])
                modifyRecordOperation.savePolicy = .allKeys
                modifyRecordOperation.qualityOfService = .userInitiated
                modifyRecordOperation.modifyRecordsCompletionBlock = { _, _, error in
                    if let error = error
                    {
                        print("Error saving: \(error)")
                    }
                }
                
                self.database.add(modifyRecordOperation)
            }
        }
    }
    
    func deleteAlarm(platform: Platform, completion: @escaping () -> ())
    {
        let predicate = NSPredicate(format: "platform == %@", platform.rawValue)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            
            guard let records = records else {
                print("No records to delete")
                return
            }
            
            for record in records
            {
                self.database.delete(withRecordID: record.recordID) { (recordID, error) in
                    if let error = error
                    {
                        print(error.localizedDescription)
                    }
                    else if let id = recordID
                    {
                        print("Deleted the record with ID: \(id)")
                    }
                    completion()
                }
            }
        }
    }
}
