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
    var controller: Controller!
    
    var stackView: UIStackView
    var label: UILabel
    var containerView: UIView
    var faceView: FaceView
    var dial: Dial
    
    var containerViewSizeConstraint: NSLayoutConstraint!
    
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
        
        super.init(nibName: nil, bundle: nil)
        
        controller = Controller(delegate: self)
        
        dial.delegate = controller
        
        view.backgroundColor = Color.faceFill.color
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
        
        controller.notificationService.requestAuthorizationToDisplayNotifications()
        
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

extension ViewController: ControllerDelegate
{
    func configureElements(interval: Double, manual: Bool)
    {
        self.dial.doubleValue = interval
        self.dial.setNeedsDisplay()
        self.label.text = interval.durationString
    }
}
