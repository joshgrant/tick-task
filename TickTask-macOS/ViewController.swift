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

let currentTaskGroupNameKey = "me.joshgrant.TickTask.currentTaskGroupName"
let currentTaskDurationKey = "me.joshgrant.TickTask.currentTaskDuration"

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
    var currentTaskGroup: TaskGroup?
    var maxMinutes: CGFloat = 60.0
    var numDivisions: Int = 12 // Corresponds to 5 minute intervals
    var statusItem: NSStatusItem?
    var optionKeyPressed: Bool = false
    
    // MARK: Interface Outlets
    
    @IBOutlet weak var nameField: NSTextField!
    @IBOutlet weak var durationField: NSTextField!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var panGesture: NSPanGestureRecognizer!
    
    // MARK: Overridden Properties
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        requestAuthorizationToDisplayNotifications()
        
        populateTaskGroupFieldWithValueFromUserDefaults()
        
        configureSceneView()
        
        super.viewDidLoad()
    }
    
    @objc func secondTimerUpdated(_ timer: Timer)
    {
        if let _ = startDate
        {
            let currentTimeInterval = currentDurationWithoutCountdown - currentCountdownTimerValue()
            
            updateStatusItemIconWithTimeInterval(timeInterval: currentTimeInterval)
            updateDurationFieldWithTimeInterval(timeInterval: currentTimeInterval)
            updateDialRotationWithTimeInterval(timeInterval: currentTimeInterval)
            
            if currentTimeInterval <= 0
            {
                countdownTimerDidComplete(timer: timer)
            }
        }
    }
    
    func requestAuthorizationToDisplayNotifications()
    {
        let center = UNUserNotificationCenter.current()
        
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
    }
    
    func populateTaskGroupFieldWithValueFromUserDefaults()
    {
        if let name = UserDefaults.standard.string(forKey: currentTaskGroupNameKey)
        {
            nameField.stringValue = name
        }
        
        if let taskGroup = currentTaskGroup
        {
            setTooltipForTaskNameField(taskGroup: taskGroup)
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
                //                sceneView.resignFirstResponder()
            }
        }
    }
    
    // MARK: Interface Actions
    
    @IBAction func handlePanGesture(_ gesture: NSPanGestureRecognizer)
    {
        guard let dial = getDial() else { return }
        
        let location = gesture.location(in: sceneView)
        
        let origin = calculateOriginOfSceneView(sceneView: sceneView)
        
        let angle = calculateAngleOfDialFromOrigin(origin: origin, andCursorLocation: location)
        
        switch gesture.state
        {
        case .began:
            userBeganDraggingDial(dial: dial, angle: angle)
        case .changed:
            updateDialRotation(dial: dial, angle: angle)
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
    
    func calculateAngleOfDialFromOrigin(origin: NSPoint, andCursorLocation location: NSPoint) -> CGFloat
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
        let remainder = angle.remainder(dividingBy: (CGFloat.pi * 2) / CGFloat(numDivisions))
        angle -= remainder
        
        return angle
    }
    
    func updateDialRotation(dial: SCNNode, angle: CGFloat)
    {
        dial.runAction(SCNAction.rotateTo(x: 0, y: angle, z: 0, duration: 0))
        
        updateDurationFieldWithTimeInterval(timeInterval: angleToTimeInterval(angle))
        updateStatusItemIconWithTimeInterval(timeInterval: angleToTimeInterval(angle))
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
            color = .green
        case .userDragging:
            color = .orange
        case .countdown:
            color = .red
        }
        
        dial.geometry?.firstMaterial?.diffuse.contents = color
        dial.geometry?.firstMaterial?.emission.contents = color
    }
    
    func updateDialRotationWithTimeInterval(timeInterval: TimeInterval)
    {
        guard let dial = getDial() else { return }
        
        dial.runAction(SCNAction.rotateTo(x: 0, y: timeIntervalToAngle(timeInterval), z: 0, duration: 0))
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
        let content = UNMutableNotificationContent()
        content.title = self.currentTaskGroup?.name ?? "Task Complete"
        content.body = "Completed at \(Date())"
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
    
    // ---------------------------
    
    func updateDurationFieldWithTimeInterval(timeInterval: TimeInterval)
    {
        // Separate components into minutes and seconds
        let minutes = Int(floor(timeInterval / 60))
        let seconds = Int(timeInterval) % 60
        
        let string = "\(String(format: "%02d", minutes))m \(String(format: "%02d", seconds))s"
        
        // Then, set the duration field
        durationField.stringValue = string
    }
    
    func updateStatusItemIconWithTimeInterval(timeInterval: TimeInterval)
    {
        statusItem?.button?.image = StatusBarIconView.imageWithRotation(angle: timeIntervalToAngle(timeInterval))
    }
    
    func currentCountdownTimerValue() -> TimeInterval
    {
        if let startDate = startDate
        {
            return Date().timeIntervalSince(startDate)
        }
        
        return 0
    }
    
    func countdownTimerDidComplete(timer: Timer)
    {
        // Add a new task to the task group
        // Reset the timer to the last number
        // Sound an alarm
        
        let task = Task(context: Database.container.viewContext)
        task.duration = currentDurationWithoutCountdown
        
        if let currentTaskGroup = currentTaskGroup
        {
            currentTaskGroup.addToTasks(task)
            setTooltipForTaskNameField(taskGroup: currentTaskGroup)
        }
        
        Database.save()
        
       resetTimerAndDate()
        
    }
    
    func userSetTimerDurationToZero()
    {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        guard let dial = getDial() else { return }
        
        setDial(dial, toState: .inactive)
        
        resetTimerAndDate()
    }
    
    func resetTimerAndDate()
    {
        secondTimer?.invalidate()
        secondTimer = nil
        startDate = nil
    }
    
    // func setTooltipForTaskNameField
    
    func setTooltipForTaskNameField(taskGroup: TaskGroup)
    {
        nameField.toolTip = "\(taskGroup.totalDuration)"
    }
    
    // func displayAutocompleteDropdownList()
    
    // func hideAutocompleteDropdownList()
    
    // func highlightSelectedDropdownRow(highlighted: Bool)
    
    // func navigateToPreviousAutocompleteSuggestion()
    
    // func navigateToNextDropdownRow()
    
    // func autocompleteSuggestionSelected(suggestion: String)
    // Use the suggestion from the autocomplete
    
    // func showRightClickMenuOnDropdownList()
    
    // func hideRightClickMenuOnDropdownList()
    
    // func handleTabToNextInterfaceElement()
    
    // func handleEnterKeyPress()
    // If the button is selected - start or stop
    // If an autocomplete suggestion is selected - change the current task
    
    func handleNameTextFieldDidEndEditing(nameTextField: NSTextField)
    {
        if let exactMatch = TaskGroup.taskGroupMatching(name: nameTextField.stringValue)
        {
            currentTaskGroup = exactMatch
        }
        else
        {
            let newTaskGroup = TaskGroup.createNewTaskGroup(name: nameTextField.stringValue)
            currentTaskGroup = newTaskGroup
            saveUserDefaultForTaskGroup(taskGroup: newTaskGroup)
        }
        
        if let taskGroup = currentTaskGroup
        {
            setTooltipForTaskNameField(taskGroup: taskGroup)
        }
    }
    
    func saveUserDefaultForTaskGroup(taskGroup: TaskGroup)
    {
        UserDefaults.standard.set(taskGroup.name, forKey: currentTaskGroupNameKey)
        UserDefaults.standard.set(currentDurationWithoutCountdown, forKey: currentTaskDurationKey)
    }
    
    // It would be nice in the future to allow smaller increment drag if the user
    // presses the option key
    override func flagsChanged(with event: NSEvent) {
        print(event)
    }
}

extension ViewController: NSTextFieldDelegate
{
    func controlTextDidEndEditing(_ obj: Notification)
    {
        if let textField = obj.object as? NSTextField
        {
            if textField.isEqual(nameField)
            {
                handleNameTextFieldDidEndEditing(nameTextField: textField)
            }
        }
    }
    
    func controlTextDidChange(_ obj: Notification)
    {
        if let _ = obj.object as? NSTextField
        {
            //            print(textField.stringValue)
        }
        
        // Recalculate the autocomplete suggestions for the segment
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
