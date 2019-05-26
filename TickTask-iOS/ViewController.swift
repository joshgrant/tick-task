//
//  ViewController.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/15/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController
{
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var faceView: FaceView!
    @IBOutlet weak var dialView: DialView!
    
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    
    var tick: Timer?
    var startDate: Date?
    var currentDurationWithoutCountdown: TimeInterval = 0
    var maxMinutes: CGFloat = 60.0
    var numDivisions: Int = 12 // Corresponds to 5 minute intervals
    
//    var dialImage: DialImage!
    
//    var faceImageInactive: UIImage!
//    var faceImageSelected: UIImage!
//    var faceImageCountdown: UIImage!
    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureInterfaceElements(state: .inactive)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    // MARK: Interface Actions
    
    var number: Int = 0
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer)
    {
        let location = sender.location(in: dialView)
        let center = dialView.bounds.center
        var angle: CGFloat = location.angleFromPoint(point: center)
        
        // When the user lets go, the number of touches goes to 1...
        
        switch sender.state
        {
        case .began:
            userBeganDragging()
        case .changed:
            number = sender.numberOfTouches
            angle.snap(to: number <= 1 ? 12 : 60)
            configureInterfaceElements(state: .selected, angle: angle)
        case .ended:
            angle.snap(to: number <= 1 ? 12 : 60)
            userEndedDragging(angle: angle)
        default:
            break
        }
    }
    
    func userBeganDragging()
    {
        invalidateTimersAndDates()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func userEndedDragging(angle: CGFloat)
    {
        if angle.distance(to: -CGFloat.pi * 2) == 0
        {
            invalidateTimersAndDates()
            configureInterfaceElements(state: .inactive, angle: angle)
        }
        else
        {
            setTimerToActive(angle: angle)
        }
    }
    
    func invalidateTimersAndDates()
    {
        tick?.invalidate()
        tick = nil
        startDate = nil
    }
    
    func durationString(with angle: CGFloat) -> String
    {
        let dateComponents = angle.toInterval().dateComponents
        return DateComponentsFormatter.currentDurationFormatter.string(from: dateComponents) ?? ""
    }
    
    func configureInterfaceElements(state: DialState, angle: CGFloat? = nil)
    {
        let angle: CGFloat = angle ?? currentInterval.toAngle()
        
        dialView.angle = angle
        dialView.state = state
        dialView.setNeedsDisplay()
        
        label.text = durationString(with: angle)
    }
    
    func setTimerToActive(angle: CGFloat)
    {
        currentDurationWithoutCountdown = angle.toInterval()
        
        guard currentDurationWithoutCountdown > 0 else { return }
        
        configureInterfaceElements(state: .countdown, angle: angle)
        
        startDate = Date()
        
        tick = initializeSecondTimer()
        RunLoop.main.add(tick!, forMode: .common)
        tick?.fire()
        
        requestAuthorizationToDisplayNotifications()
    }
    
    func requestAuthorizationToDisplayNotifications()
    {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (success, error) in
            
            if let error = error { print(error) }
            
            guard success else { return }
            
            center.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                
                // Register for remote (aka push) notifications (on the main thread)
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
                
                let content = UNMutableNotificationContent()
                content.title = "Time's Up!"
                content.body = "\(self.currentDurationWithoutCountdown.minutes) minutes completed"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.currentDurationWithoutCountdown,
                                                                repeats: false)
                
                let request = UNNotificationRequest(identifier: "tick_task_notification", content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                })
            }
        }
    }
    
    func initializeSecondTimer() -> Timer
    {
        return Timer(timeInterval: 0.5,
                     target: self,
                     selector: #selector(secondTimerUpdated(_:)),
                     userInfo: nil,
                     repeats: true)
    }
    
    @objc func secondTimerUpdated(_ timer: Timer)
    {
        configureInterfaceElements(state: .countdown)
        
        if currentInterval <= 0
        {
            invalidateTimersAndDates()
            configureInterfaceElements(state: .inactive, angle: -CGFloat.pi * 2)
        }
    }
}

