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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var faceView: FaceView!
    @IBOutlet weak var dialView: DialView!
    
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var dialWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureInterfaceElements(state: .inactive)
        requestAuthorizationToDisplayNotifications()
        
        // This only needs to get called when we update the drawing code
        // Shouldn't really be ever... But these are for the launch screen...
//         drawPrerenderedImages()
        
        configureStackAxis(size: view.frame.size)
        dialWidthConstraint.constant = view.frame.size.width
        dialWidthConstraint.priority = UILayoutPriority.required
        
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
        if size.width > size.height // Landscape
        {
            self.stackView.axis = .horizontal
        }
        else // Portrait
        {
            self.stackView.axis = .vertical
        }
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
    
    // MARK: Render Image
    
    func drawPrerenderedImages()
    {
        let sizes: [CGSize] = [
            CGSize(square: 320),
            CGSize(square: 320 * 2),
            CGSize(square: 320 * 3),
            CGSize(square: 375),
            CGSize(square: 375 * 2),
            CGSize(square: 375 * 3),
            CGSize(square: 414),
            CGSize(square: 414 * 2),
            CGSize(square: 414 * 3),
            CGSize(square: 768),
            CGSize(square: 768 * 2),
            CGSize(square: 768 * 3),
            CGSize(square: 1024),
            CGSize(square: 1024 * 2),
            CGSize(square: 1024 * 3),
            CGSize(square: 110),
            CGSize(square: 220),
        ]
        
        var images: [UIImage] = []
        
        for size in sizes
        {
            UIGraphicsBeginImageContext(size)
            faceView.draw(CGRect(origin: CGPoint.zero, size: size))
//            dialView.angle = TimeInterval(exactly: 60 * 30)!.toAngle()
            dialView.draw(CGRect(origin: CGPoint.zero, size: size))
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            images.append(image)
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first ?? ""
        print(documentsDirectory)
        
        for image in images
        {
            FileManager.default.createFile(atPath: "\(documentsDirectory)/\(Int(image.size.width)).png",
                contents: image.pngData(),
                attributes: nil)
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
