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
    func noAlarmsExistOnTheServer()
    func alarmWasRemotelyUpdated(date: Date, timeInterval: TimeInterval, platform: Platform)
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
        
        createSubscription()
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
                print("Got some alarms: \(records!)")
                
                guard alarmRecords.count > 0 else
                {
                    // We need to delete all of the alarms?
                    // In the case that there are no alarm records, we have
                    // deleted all of them.
                    self.delegate.noAlarmsExistOnTheServer()
                    return
                }
                
                for alarmRecord in alarmRecords
                {
                    let alarm = Alarm(record: alarmRecord)
                    
                    self.delegate.alarmWasRemotelyUpdated(date: alarm.alarmDate,
                                                          timeInterval: alarm.timeInterval,
                                                          platform: alarm.platform)
                }
                
            }
            else
            {
                print("No Records")
            }
        }
    }
    
    func uploadAlarm(alarm: Alarm)
    {
        database.save(alarm.record) { (record, error) in
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
