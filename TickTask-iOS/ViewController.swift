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
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer)
    {
        let location = sender.location(in: dialView)
        let center = dialView.bounds.center
        let snap: CGFloat = bestGuessForNumberOfTouches() == 1 ? 12 : 60
        let angle: CGFloat = location.angleFromPoint(point: center, snapTo: snap)
        
        switch sender.state
        {
        case .began:
            userBeganDragging(angle: angle)
        case .changed:
            trackTouch(sender: sender)
            configureInterfaceElements(state: .selected, angle: angle)
        case .ended:
            userEndedDragging(angle: angle)
        default:
            break
        }
    }
    
    // This creates a buffer so that when the user takes their fingers off
    // the screen, it won't think they have just one finger
    var previousNumberOfTouches: [Int] = []
    
    func trackTouch(sender: UIPanGestureRecognizer, keep amount: Int = 3)
    {
        previousNumberOfTouches.append(sender.numberOfTouches)
        
        if previousNumberOfTouches.count > amount
        {
            previousNumberOfTouches.removeFirst()
        }
    }
    
    func bestGuessForNumberOfTouches() -> Int
    {
        guard previousNumberOfTouches.count > 0 else { return 0 }
        
        var total: CGFloat = 0
        
        for numberOfTouches in previousNumberOfTouches
        {
            total += CGFloat(numberOfTouches)
        }
        
        total /= CGFloat(previousNumberOfTouches.count)
        
        return Int(total.rounded())
    }
}

