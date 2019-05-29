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
    
    @objc var durationText: String = ViewController.durationString(with: 0)
    
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
//        
//        viewWidth.constant = 1000
//        view.needsLayout = true
    }
}
