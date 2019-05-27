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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureInterfaceElements(state: .inactive)
        requestAuthorizationToDisplayNotifications()
        
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
            userBeganDragging(angle: angle)
        case .changed:
            number = sender.numberOfTouches
            angle.snap(to: number <= 1 ? 12 : 60)
            configureInterfaceElements(state: .selected, angle: angle)
        case .ended:
            // So when the user lets go, we don't lose the last touch...
            angle.snap(to: number <= 1 ? 12 : 60)
            userEndedDragging(angle: angle)
        default:
            break
        }
    }
}

