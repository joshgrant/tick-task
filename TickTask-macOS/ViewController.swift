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
    
    @objc dynamic var durationString: String = "00m 00s"
    
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
    
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var leftMousePan: NSPanGestureRecognizer!
    @IBOutlet weak var rightMousePan: NSPanGestureRecognizer!
    @IBOutlet weak var stackView: NSStackView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        requestAuthorizationToDisplayNotifications()
        configureSceneView()
        configureLighting()
        registerForNotifications(flag: true)
        
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
    func configureLighting()
    {
        guard let scene = sceneView.scene else { return }
        
        if let light = scene.rootNode.childNode(withName: "Light", recursively: false)
        {
            light.light?.intensity = isDarkMode ? 200 : 5000
        }
    }
    
    func configureInterfaceElements(angle: CGFloat? = nil, userUpdate: Bool = false)
    {
        let angle: CGFloat = angle ?? currentInterval.toAngle()
        
        if userUpdate || Int(countdownRemaining) % 60 == 0
        {
            statusItem?.button?.image = NSImage.dialWithRotation(angle: angle)
        }
        
        updateDurationField(with: angle)
        updateDialRotation(with: angle)
    }
    
    func configureSceneView()
    {
        if let sceneView = sceneView
        {
            if let scene = SCNScene(named: "./SceneKitAssets.scnassets/timer.scn")
            {
                sceneView.scene = scene
                sceneView.allowsCameraControl = false
                sceneView.antialiasingMode = .multisampling4X
                sceneView.resignFirstResponder()
            }
        }
        
        setDialTo(state: .inactive)
    }
}

// MARK: Gesture
extension ViewController
{
    @IBAction func handlePanGesture(_ gesture: NSPanGestureRecognizer)
    {
        let location = gesture.location(in: sceneView)
        let origin = sceneView.center
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
        setDialTo(state: .userDragging)
        
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
            setTimerToActive()
        }
    }
}

// MARK: Dial
extension ViewController
{
    func getDial() -> SCNNode?
    {
        guard let scene = sceneView.scene else { return nil }
        
        if let dial = scene.rootNode.childNode(withName: "Dial", recursively: false)
        {
            return dial
        }
        
        return nil
    }
    
    func setDialTo(state: DialState)
    {
        guard let dial = getDial() else { return }
        
        let color: NSColor
        
        switch state
        {
        case .inactive:
            color = NSColor.systemGreen
        case .userDragging:
            color = NSColor.systemYellow
        case .countdown:
            color = NSColor.systemRed
        }
        
        dial.geometry?.firstMaterial?.diffuse.contents = color
        dial.geometry?.firstMaterial?.emission.contents = color
    }
    
    func updateDialRotation(with angle: CGFloat)
    {
        guard let dial = getDial() else { return }
        
        dial.runAction(SCNAction.rotateTo(x: 0, y: angle, z: 0, duration: 0))
    }
}

// MARK: Timer
extension ViewController
{
    func setTimerToActive()
    {
        guard let dial = getDial() else { return }
        
        // We subtract 1 because when we convert the angle to the interval,
        // we round it up. However, rounding it down causes some problems,
        // so this is a fix, but not perfect...
        // Also, this shouldn't rely on the rotation of the dial... there should
        // be a less hacky way to achieve this...
        currentDurationWithoutCountdown = dial.eulerAngles.y.toInterval() - 1
        
        guard currentDurationWithoutCountdown > 0 else { return }
        
        setDialTo(state: .countdown)
        
        startDate = Date()
        
        secondTimer = initializeSecondTimer()
        RunLoop.main.add(secondTimer!, forMode: .common)
        secondTimer?.fire()
        
        createNotification()
    }
    
    func initializeSecondTimer() -> Timer
    {
        return Timer(timeInterval: 1.0,
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
        setDialTo(state: .inactive)
        
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
        configureLighting()
    }
    
    func scheduleNotification()
    {
        let minutes = self.currentDurationWithoutCountdown.minutes
        
        let minuteText: String
        let completedText = String.localizedStringWithFormat("completed")
        
        if minutes == 1
        {
            minuteText = String.localizedStringWithFormat("minute")
        }
        else
        {
            minuteText = String.localizedStringWithFormat("minutes")
        }
        
        let content = UNMutableNotificationContent()
        content.title = String.localizedStringWithFormat("Task Done")
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
