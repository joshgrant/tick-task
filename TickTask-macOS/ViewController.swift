//
//  ViewController.swift
//  TickTask
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa
import AVFoundation
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
    
    // MARK: Interface Outlets
    
    @IBOutlet weak var durationField: NSTextField!
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
        
        super.viewDidLoad()
    }
    
    @objc func secondTimerUpdated(_ timer: Timer)
    {
        let currentTimeInterval = currentDurationWithoutCountdown - countdownRemaining
        let angle = timeIntervalToAngle(currentTimeInterval)
        
        configureInterfaceElementsWith(angle: angle)
        
        if currentTimeInterval <= 0
        {
            countdownTimerDidComplete(timer: timer)
        }
    }
    
    func configureInterfaceElementsWith(angle: CGFloat)
    {
        // Update the status bar icon...
        // But this might be expensive, so we should think about when we should do this..
        
        // Only update it once a minute
        if Int(countdownRemaining) % 60 == 0
        {
            statusItem?.button?.image = StatusBarIconView.imageWithRotation(angle: angle)
        }
        
        updateDurationField(with: angle)
        updateDialRotation(with: angle)
    }
    
    func requestAuthorizationToDisplayNotifications()
    {
        let center = UNUserNotificationCenter.current()
        
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
    }
    
    func configureSceneView()
    {
        if let sceneView = sceneView
        {
            if let scene = SCNScene(named: "SceneKitAssets.scnassets/timer-3.scn")
            {
                sceneView.scene = scene
                sceneView.allowsCameraControl = false
                sceneView.antialiasingMode = .multisampling16X
                sceneView.resignFirstResponder()
                
                guard let dial = getDial() else { return }
                
                setDial(dial, toState: .inactive)
            }
        }
    }
    
    // MARK: Interface Actions
    
    @IBAction func handlePanGesture(_ gesture: NSPanGestureRecognizer)
    {
        guard let dial = getDial() else { return }
        
        let location = gesture.location(in: sceneView)
        let origin = calculateOriginOfSceneView(sceneView: sceneView)
        var angle: CGFloat = 0
        
        if gesture.isEqual(leftMousePan)
        {
            angle = calculateAngleOfDialFromOrigin(origin: origin, andCursorLocation: location, divisions: numDivisions)
        }
        else if gesture.isEqual(rightMousePan)
        {
            angle = calculateAngleOfDialFromOrigin(origin: origin, andCursorLocation: location, divisions: 60)
        }
        
        switch gesture.state
        {
        case .began:
            userBeganDraggingDial(dial: dial, angle: angle)
        case .changed:
            configureInterfaceElementsWith(angle: angle)
        case .ended:
            userEndedDraggingDial(dial: dial, angle: angle)
        default:
            debugPrint("Gesture state not handled.")
        }
    }
    
    func userBeganDraggingDial(dial: SCNNode, angle: CGFloat)
    {
        setDial(dial, toState: .userDragging)
        
        secondTimer?.invalidate()
        secondTimer = nil
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func userEndedDraggingDial(dial: SCNNode, angle: CGFloat)
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
    
    func calculateOriginOfSceneView(sceneView: SCNView) -> NSPoint
    {
        return NSPoint(x: sceneView.bounds.size.width / 2.0, y: sceneView.bounds.size.height / 2.0)
    }
    
    func calculateAngleOfDialFromOrigin(origin: NSPoint, andCursorLocation location: NSPoint, divisions: Int) -> CGFloat
    {
        // We calculate the angle of the mouse location from the origin
        // Angle 0 is the right side of the unit circle
        var angle = atan2(location.y - origin.y, location.x - origin.x)
        
        // Subtract pi/2 (90 degrees) to start the dial at the top
        angle -= CGFloat.pi/2
        
        // Because the angle is weird,,, i.e it is -4.712 *and* 1.570 at the left, and because the
        // top-left quadrant has positive numbers when everything else is negative, we do some adjustments to
        // make the top left quadrant compliant with everything else
        if angle > 0
        {
            angle = -CGFloat.pi * 2 + angle
        }
        
        // Now we want to make sure the dial "snaps" to different locations.
        // This is achieved by subtracting the remainder from the value
        // This gives us twice the number of snaps (because a full rotation is 2 pi)
        let remainder = angle.remainder(dividingBy: (CGFloat.pi * 2) / CGFloat(divisions))
        angle -= remainder
        
        return angle
    }
    
    func getDial() -> SCNNode?
    {
        guard let scene = sceneView.scene else { return nil }
        
        if let dial = scene.rootNode.childNode(withName: "Dial", recursively: false)
        {
            return dial
        }
        
        return nil
    }
    
    func setDial(_ dial: SCNNode, toState state: DialState)
    {
        let color: NSColor
        
        switch state
        {
        case .inactive:
            color = NSColor(calibratedHue: 105.0/360.0, saturation: 0.77, brightness: 0.76, alpha: 1.0)
        case .userDragging:
            color = NSColor(calibratedHue: 48.0/360.0, saturation: 0.82, brightness: 0.9, alpha: 1.0)
        case .countdown:
            color = NSColor(calibratedHue: 3.0/360.0, saturation: 0.92, brightness: 1.0, alpha: 1.0)
        }
        
        dial.geometry?.firstMaterial?.diffuse.contents = color
        dial.geometry?.firstMaterial?.emission.contents = color
        
        print(sceneView.scene?.rootNode.childNodes)
        
        if let scene = sceneView.scene, let face = scene.rootNode.childNode(withName: "Face", recursively: false)
        {
            face.geometry?.material(named: "Border")?.diffuse.contents = NSColor.white
            face.geometry?.material(named: "Border")?.emission.contents = NSColor.black
            
            face.geometry?.material(named: "Back")?.diffuse.contents = NSColor.black
            face.geometry?.material(named: "Back")?.emission.contents = NSColor.black
        }
    }
    
    func updateDialRotation(with angle: CGFloat)
    {
        guard let dial = getDial() else { return }
        
        dial.runAction(SCNAction.rotateTo(x: 0, y: angle, z: 0, duration: 0))
    }
    
    
    func setTimerToActive()
    {
        guard let dial = getDial() else { return }
        
        setDial(dial, toState: .countdown)
        
        startDate = Date()
        
        currentDurationWithoutCountdown = angleToTimeInterval(dial.eulerAngles.y)
        
        secondTimer = initializeSecondTimer()
        RunLoop.main.add(secondTimer!, forMode: .common)
        
        // We need more of this...
        guard currentDurationWithoutCountdown > 0 else { return }
        
        createNotification()
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
    
    func scheduleNotification()
    {
        let minutes = minutesFromTimeInterval(timeInterval: self.currentDurationWithoutCountdown)
        
        let content = UNMutableNotificationContent()
        content.title = "Task Done"
        // The body of the notification. Use -[NSString localizedUserNotificationStringForKey:arguments:] to provide a string that will be localized at the time that the notification is presented.
        content.body = "\(minutes) minutes completed"
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
    
    func initializeSecondTimer() -> Timer
    {
        return Timer(timeInterval: 1.0,
                     target: self,
                     selector: #selector(secondTimerUpdated(_:)),
                     userInfo: nil,
                     repeats: true)
    }
    
    func updateDurationField(with angle: CGFloat)
    {
        let timeInterval = angleToTimeInterval(angle)
        // Separate components into minutes and seconds
        let minutes = minutesFromTimeInterval(timeInterval: timeInterval)
        let seconds = secondsFromTimeInterval(timeInterval: timeInterval)
        
        let string = "\(String(format: "%02d", minutes))m \(String(format: "%02d", seconds))s"
        
        // Then, set the duration field
        durationField.stringValue = string
    }
    
    func minutesFromTimeInterval(timeInterval: TimeInterval) -> Int
    {
        return Int(floor(timeInterval / 60))
    }
    
    func secondsFromTimeInterval(timeInterval: TimeInterval) -> Int
    {
        return Int(timeInterval) % 60
    }
    
    var countdownRemaining: TimeInterval {
        get {
            return (startDate != nil) ? Date().timeIntervalSince(startDate!) : TimeInterval.zero
        }
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
        guard let dial = getDial() else { return }
        
        setDial(dial, toState: .inactive)
        
        secondTimer?.invalidate()
        secondTimer = nil
        startDate = nil
    }
}

// MARK: Utility Functions

extension ViewController
{
    func timeIntervalToAngle(_ timeInterval: TimeInterval) -> CGFloat
    {
        // Start with the number of seconds and convert it to minutes
        let minutes = CGFloat(timeInterval) / 60
        
        // Then, get a normalized value between 0 and 1
        let normalized = minutes / maxMinutes
        
        // Then, interpolate that value between 0 and 2 pi
        let interpolated = normalized * (CGFloat.pi * 2)
        
        // Then, convert the angle to a negative, because that's what we have
        let angle = interpolated * -1
        
        return angle
    }
    
    func angleToTimeInterval(_ angle: CGFloat) -> TimeInterval
    {
        // The angles are all negative, so we need to convert it to a positive angle
        let positiveAngle = angle * -1
        
        // Start with the angle and convert it to a value from 0-1
        let normalized = positiveAngle / (CGFloat.pi * 2)
        
        // Then, interpolate that value between 0 and maxMinutes (60)
        let interpolated = normalized * maxMinutes
        
        // Then, convert the interpolated value to seconds
        let seconds = interpolated * 60
        
        return TimeInterval(ceil(seconds))
    }
}
