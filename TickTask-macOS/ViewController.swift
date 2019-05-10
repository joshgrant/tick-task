//
//  ViewController.swift
//  TickTask
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa
import SceneKit
import UserNotifications

let currentTaskGroupNameKey = "currentTaskGroupName"
let currentTaskDurationKey = "currentTaskDuration"

enum DialState
{
    case inactive
    case userDragging
    case countdown
}

class ViewController: NSViewController
{
    // MARK: Shared Properties
    
    var secondTimer: Timer?
    var startDate: Date?
    var currentDurationWithoutCountdown: TimeInterval = 0
    var maxMinutes: CGFloat = 60.0
    var numDivisions: Int = 12 // Corresponds to 5 minute intervals
    var statusItem: NSStatusItem?
    
    @objc dynamic var durationString: String = NSLocalizedString("00m 00s", comment: "")
    
    var countdownRemaining: TimeInterval {
        get {
            return (startDate != nil) ? Date().timeIntervalSince(startDate!) : TimeInterval.zero
        }
    }
    
    var currentInterval: TimeInterval {
        get {
            return currentDurationWithoutCountdown - countdownRemaining
        }
    }
    
    // MARK: Interface Outlets
    
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var imageView: ImageView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        view.translatesAutoresizingMaskIntoConstraints = true
        
        requestAuthorizationToDisplayNotifications()
        imageView.image = NSImage.interactionDialWithRotation(angle: 0, state: .inactive)
        imageView.delegate = self
        
        super.viewDidLoad()
    }
    
    func updateDurationField(with angle: CGFloat)
    {
        let timeInterval = angle.toInterval()
        
        durationString = "\(String(format: "%02d", timeInterval.minutes))m " +
        "\(String(format: "%02d", timeInterval.seconds))s"
    }
}

// MARK: Scene View
extension ViewController
{
    func configureInterfaceElements(angle: CGFloat? = nil, userUpdate: Bool = false)
    {
        let angle: CGFloat = angle ?? currentInterval.toAngle()
        
        updateDurationField(with: angle)
        
        if userUpdate || Int(countdownRemaining) % 10 == 0
        {
            let state: DialState = userUpdate ? .userDragging : .countdown
            self.imageView.image = NSImage.interactionDialWithRotation(angle: angle, state: state)
        }
        
        if userUpdate || Int(countdownRemaining) % 60 == 0
        {
            statusItem?.button?.image = NSImage.statusItemDialWithRotation(angle: angle)
        }
    }
}

// MARK: Image View Mouse Delegate
extension ViewController: ImageViewMouseDelegate
{
    func imageViewMouseEvent(_ event: NSEvent)
    {
        handlePanGesture(with: event)
    }
}

// MARK: Gesture
extension ViewController
{
    func handlePanGesture(with event: NSEvent)
    {
        let viewLocation = self.view.topLevelView.convert(event.locationInWindow, to: imageView)
        let origin = imageView.center
        var angle: CGFloat = viewLocation.angleFromPoint(point: origin)
        
        if (event.type == .rightMouseUp ||
            event.type == .rightMouseDown ||
            event.type == .rightMouseDragged ||
            event.modifierFlags != .init(rawValue: 0))
        {
            angle.snap(to: 60)
        }
        else
        {
            angle.snap(to: 12)
        }

        switch event.type
        {
        case .leftMouseDown, .rightMouseDown:
            userBeganDragging(angle: angle)
        case .leftMouseDragged, .rightMouseDragged:
            configureInterfaceElements(angle: angle, userUpdate: true)
        case .leftMouseUp, .rightMouseUp:
            userEndedDragging(angle: angle)
        default:
            debugPrint("Event type not handled")
        }
    }
    
    func userBeganDragging(angle: CGFloat)
    {
        secondTimer?.invalidate()
        secondTimer = nil
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func userEndedDragging(angle: CGFloat)
    {
        // Unless the user drags it back to zero...
        
        if angle == 0
        {
            userSetTimerDurationToZero()
        }
        else
        {
            setTimerToActive(angle: angle)
        }
    }
}

// MARK: Timer
extension ViewController
{
    func setTimerToActive(angle: CGFloat)
    {
        currentDurationWithoutCountdown = angle.toInterval()
        
        guard currentDurationWithoutCountdown > 0 else { return }
        
        self.imageView.image = NSImage.interactionDialWithRotation(angle: angle, state: .countdown)
        
        startDate = Date()
        
        secondTimer = initializeSecondTimer()
        RunLoop.main.add(secondTimer!, forMode: .common)
        secondTimer?.fire()
        
        createNotification()
    }
    
    func initializeSecondTimer() -> Timer
    {
        return Timer(timeInterval: 0.5,
                     target: self,
                     selector: #selector(secondTimerUpdated(_:)),
                     userInfo: nil,
                     repeats: true)
    }
    
    func countdownTimerDidComplete(timer: Timer)
    {
        resetTimerAndDate()
    }
    
    func userSetTimerDurationToZero()
    {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        resetTimerAndDate()
    }
    
    func resetTimerAndDate()
    {
        self.imageView.image = NSImage.interactionDialWithRotation(angle: 0, state: .inactive)
        
        secondTimer?.invalidate()
        secondTimer = nil
        startDate = nil
    }
    
    @objc func secondTimerUpdated(_ timer: Timer)
    {
        configureInterfaceElements()
        
        if currentInterval <= 0
        {
            countdownTimerDidComplete(timer: timer)
        }
    }
}

// MARK: Notifications
extension ViewController
{
    func requestAuthorizationToDisplayNotifications()
    {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
    }
    
    func createNotification()
    {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            self.scheduleNotification()
        }
    }
    
    func scheduleNotification()
    {
        let minutes = self.currentDurationWithoutCountdown.minutes
        
        let minuteText = NSLocalizedString(minutes == 1 ? "minute" : "minutes", comment: "")
        let completedText = NSLocalizedString("completed", comment: "")
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Task Done", comment: "")
        content.body = "\(minutes) \(minuteText) \(completedText)"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.currentDurationWithoutCountdown, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
}
