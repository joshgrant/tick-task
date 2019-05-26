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
    @IBOutlet weak var dialView: DialView!
    
    @IBOutlet weak var singlePanGesture: UIPanGestureRecognizer!
    @IBOutlet weak var doublePanGesture: UIPanGestureRecognizer!
    
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
        
        // This initializes the class, not the actual image
//        dialImage = DialImage(frame: self.dialView.bounds)
        
//        faceImageInactive = dialImage.faceImage(state: .inactive)
//        faceImageSelected = dialImage.faceImage(state: .selected)
//        faceImageCountdown = dialImage.faceImage(state: .countdown)
        
        configureInterfaceElements(state: .inactive)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
//    func dialFaceImageForState(state: DialState) -> UIImage
//    {
//        switch state
//        {
//        case .countdown: return faceImageCountdown
//        case .selected: return faceImageSelected
//        case .inactive: return faceImageInactive
//        }
//    }
//    
    // MARK: Interface Actions
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer)
    {
        let location = sender.location(in: dialView)
        let center = CGPoint(x: dialView.bounds.origin.x + dialView.bounds.size.width / 2,
                             y: dialView.bounds.origin.y + dialView.bounds.size.height / 2)
        var angle: CGFloat = location.angleFromPoint(point: center)
        
        if (sender.isEqual(doublePanGesture))
        {
            angle.snap(to: 60)
        }
        else if (sender.isEqual(singlePanGesture))
        {
            angle.snap(to: 12)
        }
        
        switch sender.state
        {
        case .began:
            userBeganDragging()
        case .changed:
            configureInterfaceElements(state: .selected, angle: angle)
        case .ended:
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
//            dialView.faceImageView.image = faceImageInactive
//            dialView.dialImageView.image = dialImage.dialImage(angle: 0, state: .inactive)
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
        
//        dialView.faceImageView.image = dialFaceImageForState(state: state)
//        dialView.dialImageView.image = dialImage.dialImage(angle: angle, state: state)
        
        label.text = durationString(with: angle)
    }
    
    func setTimerToActive(angle: CGFloat)
    {
        currentDurationWithoutCountdown = angle.toInterval()
        
        guard currentDurationWithoutCountdown > 0 else { return }
        
//        dialView.faceImageView.image = faceImageCountdown
//        dialView.dialImageView.image = dialImage.dialImage(angle: angle, state: .countdown)
        
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
                    //                    print("Add error", error)
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
            configureInterfaceElements(state: .inactive, angle: 0)
        }
    }
}

