//
//  ViewController.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/15/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit
import UserNotifications

// TODO:

// It doesn't look like the timer dial updates unless the user is dragging...

class ViewController: UIViewController
{
    var stackView: UIStackView
    var label: UILabel
    var containerView: UIView
    var faceView: FaceView
    var dial: Dial
    
    var containerViewSizeConstraint: NSLayoutConstraint!
    
    lazy var ubiquitous: Ubiquitous = {
        return Ubiquitous(delegate: self, platform: .iOS)
    }()
    var timerService: TimerService
    var notificationService: NotificationService!
    
    init()
    {
        label = UILabel()//frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.text = defaultInterval.durationString
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        faceView = FaceView()//frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        faceView.backgroundColor = .clear
        dial = Dial()//frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        dial.backgroundColor = .clear
        
        containerView = UIView()//frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        containerView.backgroundColor = .clear
        containerView.addSubview(faceView)
        containerView.addSubview(dial)
        
        stackView = UIStackView(arrangedSubviews: [label, containerView])
        
        timerService = TimerService()
        notificationService = NotificationService()
        
        super.init(nibName: nil, bundle: nil)
        
        dial.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contstraints(for child: UIView, in parent: UIView, padding: CGFloat = 0) -> [NSLayoutConstraint]
    {
        return [
            NSLayoutConstraint(item: child,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: padding),
            NSLayoutConstraint(item: child,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: padding),
            NSLayoutConstraint(item: child,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: padding),
            NSLayoutConstraint(item: child,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: padding),
        ]
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        dial.translatesAutoresizingMaskIntoConstraints = false
        faceView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        
        view.addSubview(stackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addConstraints(contstraints(for: faceView, in: containerView))
        containerView.addConstraints(contstraints(for: dial, in: containerView))
        containerView.addConstraint(NSLayoutConstraint(item: containerView,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: containerView,
                                                       attribute: .height,
                                                       multiplier: 1.0,
                                                       constant: 0.0))
//        view.addConstraints(contstraints(for: stackView, in: view))
        
        containerViewSizeConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.size.width)
        containerViewSizeConstraint.priority = .required
        
        view.addConstraints([NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            containerViewSizeConstraint])
        
        configureStackAxis(size: view.frame.size)
        
        notificationService.requestAuthorizationToDisplayNotifications()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        configureStackAxis(size: size)
    }
    
    func configureStackAxis(size: CGSize)
    {
        stackView.axis = (size.width > size.height) ? .horizontal : .vertical
    }
    
    func configureElements(interval: Double? = nil)
    {
        let interval: Double = interval ?? timerService.currentInterval
        
        self.dial.setNeedsDisplay()
        self.label.text = interval.durationString
    }
}

extension ViewController: UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension ViewController: UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        let location = gestureRecognizer.location(in: dial)
        let radius = (dial.bounds.width / 2)
        if location.distance(to: dial.bounds.center) > radius
        {
            return false
        }
        
        return true
    }
}

extension ViewController: DialDelegate
{
    func dialStartedTracking(dial: Dial)
    {
        dial.dialState = .selected
        
        timerService.invalidateTimersAndDates()
        
        configureElements(interval: dial.doubleValue)
    }
    
    func dialUpdatedTracking(dial: Dial)
    {
        configureElements(interval: dial.doubleValue)
    }
    
    func dialStoppedTracking(dial: Dial)
    {
        if dial.doubleValue == 0
        {
            dial.dialState = .inactive
            
            timerService.invalidateTimersAndDates()
        }
        else
        {
            dial.dialState = .countdown
            
            timerService.setTimerToActive(interval: dial.doubleValue) { (timer) in
                if self.timerService.currentInterval <= 0
                {
                    dial.dialState = .inactive
                    self.timerService.invalidateTimersAndDates()
                    
                    self.configureElements(interval: defaultInterval)
                }
                else
                {
                    self.configureElements()
                }
            }
            
            Ubiquitous.syncAlarm(interval: dial.doubleValue, on: .iOS)
            
            notificationService.createNotification(at: dial.doubleValue)
        }
        
        configureElements(interval: dial.doubleValue)
    }
}

extension ViewController: UbiquitousDelegate
{
    func alarmWasRemotelyUpdated(platform: Platform, date: Date)
    {
        print("Alarm updated! Create an alert")
        // We should remove the old notifications if this is the case...
        // But only for the osx apps...
        notificationService.createNotification(at: nil, at: date)
    }
}
