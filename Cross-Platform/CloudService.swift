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
    func alarmWasRemotelyUpdated(date: Date, timeInterval: TimeInterval, platform: Platform)
}

class CloudService
{
    // MARK: - Properties
    
    var container: CKContainer
    var database: CKDatabase
    var containerID: String
    
    var delegate: CloudServiceDelegate?
    
    init(delegate: CloudServiceDelegate)
    {
        self.container = CKContainer(identifier: containerIdentifier)
        self.database = container.database(with: .private)
        self.containerID = container.containerIdentifier ?? ""
        
        createSubscription()
    }
    
    // MARK: - Subscriptions
    
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
        
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: [])
        
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
                print(alarmRecords)
                
                for alarmRecord in alarmRecords
                {
                    let alarm = Alarm(record: alarmRecord)
                    
                    DispatchQueue.main.async {
                        // Create a local notification with the given alarm
                        
                        print(alarm)
                    }
                }
            }
        }
    }
    
    func uploadAlarm(alarm: Alarm)
    {
        if let record = alarm.record
        {
            database.save(record) { (record, error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                else if let alarm = record
                {
                    print("Uploaded the alarm: \(alarm)")
                }
            }
        }
    }
    
    func deleteAlarm(alarm: Alarm)
    {
        if let record = alarm.record
        {
            database.delete(withRecordID: record.recordID) { (recordID, error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                else if let id = recordID
                {
                    print("Deleted the record with ID: \(id)")
                }
                
                DispatchQueue.main.async {
                    // Remove the alarm??
                }
            }
        }
    }
}
