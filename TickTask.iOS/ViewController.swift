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
    // MARK: - Properties
    
    var stackView: UIStackView
    var label: UILabel
    var containerView: UIView
    var faceView: FaceView
    var dial: Dial
    
    var controller: Controller!
    
    var containerViewSizeConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    
    init()
    {
        label = ViewController.configureLabel()
        faceView = ViewController.configureFaceView()
        dial = ViewController.configureDial()
        containerView = ViewController.configureContainerView(faceView: faceView, dial: dial)
        stackView = ViewController.configureStackView(label: label, containerView: containerView)
        
        super.init(nibName: nil, bundle: nil)
        
        controller = Controller(delegate: self)
        controller.cloudService.createSubscription()
        dial.delegate = controller
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        containerViewSizeConstraint = NSLayoutConstraint.width(item: containerView,width: view.frame.size.width)
        containerViewSizeConstraint.priority = .required
        
        view.backgroundColor = Color.faceFill.color
        view.addSubview(stackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([NSLayoutConstraint.centerY(for: stackView, to: view.safeAreaLayoutGuide),
                             NSLayoutConstraint.centerX(for: stackView, to: view.safeAreaLayoutGuide),
                             containerViewSizeConstraint])
        
        configureStackAxis(size: view.frame.size)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Configuration
    
    func configureStackAxis(size: CGSize)
    {
        stackView.axis = (size.width > size.height) ? .horizontal : .vertical
    }
    
    class func configureStackView(label: UILabel, containerView: UIView) -> UIStackView
    {
        let stackView = UIStackView(arrangedSubviews: [label, containerView])
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    class func configureLabel() -> UILabel
    {
        let label = UILabel()
        
        label.text = defaultInterval.durationString
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        return label
    }
    
    class func configureDial() -> Dial
    {
        let dial = Dial()
        
        dial.backgroundColor = .clear
        dial.translatesAutoresizingMaskIntoConstraints = false
        
        return dial
    }
    
    class func configureFaceView() -> FaceView
    {
        let faceView = FaceView()
        
        faceView.backgroundColor = .clear
        faceView.translatesAutoresizingMaskIntoConstraints = false
        
        return faceView
    }
    
    class func configureContainerView(faceView: FaceView, dial: Dial) -> UIView
    {
        let containerView = UIView()
        
        containerView.backgroundColor = .clear
        containerView.addSubview(faceView)
        containerView.addSubview(dial)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addConstraints(NSLayoutConstraint.contstraints(for: faceView, in: containerView))
        containerView.addConstraints(NSLayoutConstraint.contstraints(for: dial, in: containerView))
        containerView.addConstraint(NSLayoutConstraint.squareConstraints(item: containerView))
        
        return containerView
    }
    
    // MARK: - System View Updates
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        configureStackAxis(size: size)
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
    func configureElements(dial: Dial?, totalInterval: Double, rotations: Int, manual: Bool)
    {
        (dial ?? self.dial).doubleValue = totalInterval - Double(rotations) * 3600
        (dial ?? self.dial).setNeedsDisplay()
        
        self.label.text = totalInterval.durationString
    }
}
