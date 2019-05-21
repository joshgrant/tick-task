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
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var singlePanGesture: UIPanGestureRecognizer!
    @IBOutlet weak var doublePanGesture: UIPanGestureRecognizer!
    
    var tick: Timer?
    var startDate: Date?
    var currentDurationWithoutCountdown: TimeInterval = 0
    var maxMinutes: CGFloat = 60.0
    var numDivisions: Int = 12 // Corresponds to 5 minute intervals
    
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
        // Do any additional setup after loading the view.
        configureInterfaceElements(state: .inactive)
    }
    
    // MARK: Interface Actions
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer)
    {
        let location = sender.location(in: imageView)
        let origin = imageView.center
        var angle: CGFloat = location.angleFromPoint(point: origin)
        
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
        
        // Remove any pending notifications
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func userEndedDragging(angle: CGFloat)
    {
        if angle == 0
        {
            invalidateTimersAndDates()
            imageView.image = DialImage.imageOfTickTask(angle: 0, size: imageView.bounds.size, state: .inactive)
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
        
        imageView.image = DialImage.imageOfTickTask(angle: angle, size: imageView.bounds.size, state: state)
        
        label.text = durationString(with: angle)
    }
    
    func setTimerToActive(angle: CGFloat)
    {
        currentDurationWithoutCountdown = angle.toInterval()
        
        let number = Int(floor(currentDurationWithoutCountdown / 300) * 5)
        
        if UIApplication.shared.supportsAlternateIcons
        {
            UIApplication.shared.setAlternateIconName("icon-\(number)min") { (error) in
            }
        }
        
        guard currentDurationWithoutCountdown > 0 else { return }
        
        imageView.image = DialImage.imageOfTickTask(angle: angle, size: imageView.bounds.size, state: .countdown)
        
        startDate = Date()
        
        tick = initializeSecondTimer()
        RunLoop.main.add(tick!, forMode: .common)
        tick?.fire()
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.criticalAlert, .sound, .alert, .badge]) { (success, error) in
            print(success, error)
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized
            {
                let content = UNMutableNotificationContent()
                content.title = "Time's Up!"
                content.body = "\(self.currentDurationWithoutCountdown.minutes) minutes completed"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.currentDurationWithoutCountdown,
                                                                repeats: false)
                
                let request = UNNotificationRequest(identifier: "tick_task_notification", content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    print("Add error", error)
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

