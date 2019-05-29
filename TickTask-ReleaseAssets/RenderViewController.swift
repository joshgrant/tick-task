//
//  RenderViewController.swift
//  TickTask-ReleaseAssets
//
//  Created by Joshua Grant on 5/28/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

class RenderViewController: ViewController
{
    @objc var simpleText: String {
        return "simple".localized
    }
    
    @objc var focusedText: String {
        return "focused".localized
    }
    
    @objc var menubarText: String {
        return "menubar".localized
    }
    
    @objc var timerText: String {
        return "timer".localized
    }
    
    @objc var openText: String {
        return "open_at_login".localized
    }
    
    @objc var quitText: String {
        return "quit_ticktask".localized
    }
    
    @objc var mobileText: String {
        return "mobile".localized
    }
    
    @objc var timesUpText: String {
        return "timer_completed_title".localized
    }
    
    @objc var durationText: String = ViewController.durationString(with: TimeInterval(25 * 60).toAngle())
    
    @objc var nowText: String {
        return "now".localized
    }
    
    @IBOutlet weak var statusItemImageView: NSImageView?
    
    @IBOutlet var viewWidth: NSLayoutConstraint!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    
    override func dialViewAngleDurationUpdate(angle: CGFloat)
    {
        self.durationText = ViewController.durationString(with: angle)
        self.statusItemImageView?.image = NSImage.statusItemDialWithRotation(angle: angle)
        self.statusItemImageView?.image?.isTemplate = false
    }
    
    override func mouseUp(with event: NSEvent)
    {
        if event.locationInWindow.x < view.window!.frame.size.width * 0.33
        {
            viewWidth.constant = CGFloat(SizeClass.iPhone.rawValue.width / 2)
            viewHeight.constant = CGFloat(SizeClass.iPhone.rawValue.height / 2)
        }
        else if event.locationInWindow.x > view.window!.frame.size.width * 0.66
        {
            viewWidth.constant = CGFloat(SizeClass.iPhoneX.rawValue.width / 2)
            viewHeight.constant = CGFloat(SizeClass.iPhoneX.rawValue.height / 2)
        }
        else
        {
            viewWidth.constant = CGFloat(SizeClass.iPad.rawValue.width / 2)
            viewHeight.constant = CGFloat(SizeClass.iPad.rawValue.height / 2)
        }
        
        super.mouseUp(with: event)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let identifier = self.identifier?.rawValue else { return }
        
        switch identifier
        {
        case "iOS_Simple", "iOS_Timer":
            let angle = defaultAngle
            self.label.stringValue = ViewController.durationString(with: defaultAngle)
            self.dialView.angle = angle
            self.dialView.state = .inactive
        case "iOS_Focused":
            let angle = TimeInterval(25 * 60).toAngle()
            self.label.stringValue = ViewController.durationString(with: angle)
            self.dialView.angle = angle
            self.dialView.state = .selected
        case "iOS_Mobile":
            let angle = TimeInterval(12.96 * 60).toAngle()
            self.label.stringValue = ViewController.durationString(with: angle)
            self.dialView.angle = angle
            self.dialView.state = .countdown
        default:
            break
        }
        
    }
}
