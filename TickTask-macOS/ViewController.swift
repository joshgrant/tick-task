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
    
    var isDarkMode: Bool {
        get {
            return UserDefaults.standard.string(forKey: "AppleInterfaceStyle") != nil
        }
    }
    
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
    
    @IBOutlet weak var leftMousePan: NSPanGestureRecognizer!
    @IBOutlet weak var rightMousePan: NSPanGestureRecognizer!
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var imageView: NSImageView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        requestAuthorizationToDisplayNotifications()
        registerForNotifications(flag: true)
        self.imageView.image = NSImage.interactionDialWithRotation(angle: 0, state: .inactive)
        
        super.viewDidLoad()
    }
    
    override func viewWillDisappear()
    {
        registerForNotifications(flag: false)
        super.viewWillDisappear()
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
            let state: DialState
            if userUpdate
            {
                state = .userDragging
            }
            else
            {
                state = . countdown
            }
            
            self.imageView.image = NSImage.interactionDialWithRotation(angle: angle, state: state)
        }
        
        if userUpdate || Int(countdownRemaining) % 60 == 0
        {
            statusItem?.button?.image = NSImage.statusItemDialWithRotation(angle: angle)
        }
    }
}

// MARK: Gesture
extension ViewController
{
    @IBAction func handlePanGesture(_ gesture: NSPanGestureRecognizer)
    {
        let location = gesture.location(in: imageView)
        let origin = imageView.center
        var angle: CGFloat = 0
        
        if gesture.isEqual(leftMousePan)
        {
            angle = location.angleFromPoint(point: origin, snap: CGFloat(numDivisions))
        }
        else if gesture.isEqual(rightMousePan)
        {
            angle = location.angleFromPoint(point: origin, snap: 60)
        }
        
        switch gesture.state
        {
        case .began:
            userBeganDragging(angle: angle)
        case .changed:
            configureInterfaceElements(angle: angle, userUpdate: true)
        case .ended:
            userEndedDragging(angle: angle)
        default:
            debugPrint("Gesture state not handled.")
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
        //        guard let dial = getDial() else { return }
        
        // We subtract 1 because when we convert the angle to the interval,
        // we round it up. However, rounding it down causes some problems,
        // so this is a fix, but not perfect...
        // Also, this shouldn't rely on the rotation of the dial... there should
        // be a less hacky way to achieve this...
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
    func registerForNotifications(flag: Bool)
    {
        if flag
        {
            DistributedNotificationCenter.default.addObserver(self, selector: #selector(changeSystemColors(_:)), name: .init(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
        }
        else
        {
            DistributedNotificationCenter.default.removeObserver(self, name:
                .init(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
        }
    }
    
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
            // Do not schedule notifications if not authorized.
            guard settings.authorizationStatus == .authorized else { return }
            
            self.scheduleNotification()
        }
    }
    
    @objc func changeSystemColors(_ notification: NSNotification)
    {
        //        configureLighting()
    }
    
    func scheduleNotification()
    {
        let minutes = self.currentDurationWithoutCountdown.minutes
        
        let minuteText: String
        let completedText = NSLocalizedString("completed", comment: "")
        
        if minutes == 1
        {
            minuteText = NSLocalizedString("minute", comment: "")
        }
        else
        {
            minuteText = NSLocalizedString("minutes", comment: "")
        }
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Task Done", comment: "")
        // The body of the notification. Use -[NSString localizedUserNotificationStringForKey:arguments:] to provide a string that will be localized at the time that the notification is presented.
        content.body = "\(minutes) \(minuteText) \(completedText)"
        content.sound = UNNotificationSound.default
        
        print(content.body)
        
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
