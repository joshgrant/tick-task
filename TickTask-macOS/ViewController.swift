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
    var dragStartLocation: NSPoint?
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
        
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        if let name = UserDefaults.standard.string(forKey: currentTaskGroupNameKey)
        {
            nameField.stringValue = name
        }
        
        if let scene = SCNScene(named: "SceneKitAssets.scnassets/timer-3.scn")
        {
            if let sceneView = sceneView
            {
                sceneView.scene = scene
                sceneView.allowsCameraControl = false
                sceneView.antialiasingMode = .multisampling16X
                sceneView.resignFirstResponder()
            }
        }
        
        super.viewDidLoad()
    }
    
    @objc func secondTimerUpdated(_ timer: Timer)
    {
        if let _ = startDate
        {
            let currentTimeInterval = currentDurationWithoutCountdown - currentCountdownTimerValue()
            updateDurationFieldWithTimeInterval(timeInterval: currentTimeInterval)
            updateDialRotationWithTimeInterval(timeInterval: currentTimeInterval)
            
            if currentTimeInterval <= 0
            {
                countdownTimerDidComplete(timer: timer)
            }
        }
    }
    
    // MARK: Interface Actions
    
    @IBAction func handlePanGesture(_ gesture: NSPanGestureRecognizer)
    {
        switch gesture.state
        {
        case .began:
            setDialStateTo(state: .userDragging)
            dragStartLocation = gesture.location(in: sceneView)
            secondTimer?.invalidate()
            secondTimer = nil
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        case .changed:
            let currentLocation = gesture.location(in: sceneView)
            updateDialRotation(cursorLocation: currentLocation)
        case .ended:
            // Unless the user drags it back to zero...
            
            startDate = Date()
            setTimerToActive()
            setDialStateTo(state: .countdown)
        default:
            print("Braken")
        }
    }
    
    func calculateOriginOfSceneView(sceneView: SCNView) -> NSPoint
    {
        let origin = NSPoint(x: sceneView.bounds.size.width / 2.0, y: sceneView.bounds.size.height / 2.0)
        return origin
    }
    
    func calculateAngleOfDialFromOrigin(origin: NSPoint, andCursorLocation location: NSPoint) -> CGFloat
    {
        // We calculate the angle of the mouse location from the origin
        // Angle 0 is the right side of the unit circle
        var angle = atan2(cursorLocation.y - origin.y, cursorLocation.x - origin.x)
        
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
    
    func updateDialRotation(cursorLocation: NSPoint)
    {
        if let scene = sceneView.scene
        {
            if let dial = scene.rootNode.childNode(withName: "Dial", recursively: false)
            {
                let origin = calculateOriginOfSceneView(sceneView: sceneView)
                
                let angle = calculateAngleOfDialFromOrigin(origin: origin, andCursorLocation: cursorLocation)
                
                dial.runAction(SCNAction.rotateTo(x: 0, y: angle, z: 0, duration: 0))
                
                // Update the timer label?
                
                updateDurationFieldWithTimeInterval(timeInterval: angleToTimeInterval(angle))
            }
        }
    }
    
    func setDialStateTo(state: DialState)
    {
        switch state
        {
        case .inactive:
            dial.geometry?.firstMaterial?.diffuse.contents = NSColor.green
            dial.geometry?.firstMaterial?.emission.contents = NSColor.green
        case .userDragging:
            dial.geometry?.firstMaterial?.diffuse.contents = NSColor.orange
            dial.geometry?.firstMaterial?.emission.contents = NSColor.orange
        case .countdown:
            dial.geometry?.firstMaterial?.diffuse.contents = NSColor.red
            dial.geometry?.firstMaterial?.emission.contents = NSColor.red
        }
    }
    
    func updateDialRotationWithTimeInterval(timeInterval: TimeInterval)
    {
        if let scene = sceneView.scene
        {
            if let dial = scene.rootNode.childNode(withName: "Dial", recursively: false)
            {
                dial.runAction(SCNAction.rotateTo(x: 0, y: timeIntervalToAngle(timeInterval), z: 0, duration: 0))
            }
        }
    }
    
    func setTimerToActive()
    {
        if let scene = sceneView.scene
        {
            if let dial = scene.rootNode.childNode(withName: "Dial", recursively: false)
            {
                dial.geometry?.firstMaterial?.diffuse.contents = NSColor.red
                dial.geometry?.firstMaterial?.emission.contents = NSColor.red
                
                currentDurationWithoutCountdown = angleToTimeInterval(dial.eulerAngles.y)
                
                secondTimer = initializeSecondTimer()
                RunLoop.main.add(secondTimer!, forMode: .common)
            }
        }
        
        // We need more of this...
        guard currentDurationWithoutCountdown > 0 else { return }
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            // Do not schedule notifications if not authorized.
            guard settings.authorizationStatus == .authorized else {return}
            

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
                
//            }
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
        }
        
        Database.save()
        
        secondTimer?.invalidate()
        secondTimer = nil
        startDate = nil
        
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Push the banner
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
    
    func handleDurationTextFieldDidEndEditing(durationTextField: NSTextField)
    {
        durationTextField.stringValue = "Hello!"
    }
    
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
            else if textField.isEqual(durationField)
            {
                handleDurationTextFieldDidEndEditing(durationTextField: textField)
            }
        }
    }
    
    func controlTextDidChange(_ obj: Notification)
    {
        if let textField = obj.object as? NSTextField
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
