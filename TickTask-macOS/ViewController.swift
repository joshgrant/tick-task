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

class ViewController: NSViewController
{
    // MARK: Shared Properties
    
    var secondTimer: Timer?
    var startDate: Date?
    var currentDurationWithoutCountdown: TimeInterval = 0
    var maxMinutes: CGFloat = 60.0
    var numDivisions: Int = 12 // Corresponds to 5 minute intervals
    var statusItem: NSStatusItem?
    
    @objc dynamic var durationString: String = DateComponentsFormatter.currentDurationFormatter.string(from: 0)!
    
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
    @IBOutlet weak var dialView: DialView!
    @IBOutlet weak var faceView: FaceView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        view.translatesAutoresizingMaskIntoConstraints = true
        
        requestAuthorizationToDisplayNotifications()
        dialView.delegate = self
        
        super.viewDidLoad()
    }
    
    func durationString(with angle: CGFloat) -> String
    {
        let dateComponents = angle.toInterval().dateComponents
        return DateComponentsFormatter.currentDurationFormatter.string(from: dateComponents) ?? ""
    }
}

// MARK: Scene View
extension ViewController
{
    func configureInterfaceElements(angle: CGFloat? = nil, userUpdate: Bool = false)
    {
        let angle: CGFloat = angle ?? currentInterval.toAngle()
        
        // The way that cocoa bindings work allows this to update the field of text...
        durationString = durationString(with: angle)
        
        if userUpdate || Int(countdownRemaining) % 10 == 0
        {
            let state: DialState = userUpdate ? .selected : .countdown
            dialView.state = state
            dialView.angle = angle
            dialView.setNeedsDisplay(dialView.bounds)
        }
        
        if userUpdate || Int(countdownRemaining) % 60 == 0
        {
            statusItem?.button?.image = NSImage.statusItemDialWithRotation(angle: angle)
        }
    }
}

// MARK: Image View Mouse Delegate
extension ViewController: DialViewDelegate
{
    func dialViewMouseEvent(_ event: NSEvent)
    {
        handlePanGesture(with: event)
    }
}

// MARK: Gesture
extension ViewController
{
    func handlePanGesture(with event: NSEvent)
    {
        let viewLocation = self.view.topLevelView.convert(event.locationInWindow, to: dialView)
        let origin = dialView.frame.center
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
        
        configureInterfaceElements(angle: angle, userUpdate: false)
        
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
//        self.imageView.image = NSImage.interactionDialWithRotation(angle: 0, state: .inactive)
        
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
            guard granted else { return }
        }
    }
    
    func createNotification()
    {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            // Register for push notifications
//            DispatchQueue.main.async {
//                NSApp.registerForRemoteNotifications()
//            }
            
            self.scheduleNotification()
        }
    }
    
    func scheduleNotification()
    {
        let dateComponents = self.currentDurationWithoutCountdown.dateComponents
        
        let notificationTitle = "timer_completed_title".localized
        let notificationBody = DateComponentsFormatter.completedDurationFormatter.string(from: dateComponents) ?? ""
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
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
