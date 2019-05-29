//
//  ViewController+.swift
//  TickTask
//
//  Created by Joshua Grant on 5/27/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

extension ViewController
{
    static func durationString(with angle: CGFloat) -> String
    {
        let dateComponents = angle.toInterval().dateComponents
        return DateComponentsFormatter.currentDurationFormatter.string(from: dateComponents) ?? ""
    }
    
    func configureInterfaceElements(state: DialState, angle: CGFloat? = nil)
    {
        let angle: CGFloat = angle ?? ViewController.currentInterval.toAngle()
        
        dialView.angle = angle
        dialView.state = state
        
        #if os(iOS)
        dialView.setNeedsDisplay()
        label.text = durationString(with: angle)
        #elseif os(OSX)
        dialView.setNeedsDisplay(dialView.bounds)
        label.stringValue = ViewController.durationString(with: angle)
        // We only want to update this infrequently...
        statusItem?.button?.image = NSImage.statusItemDialWithRotation(angle: angle)
        #endif
    }
    
    func userBeganDragging(angle: CGFloat)
    {
        invalidateTimersAndDates()
    }
    
    func userEndedDragging(angle: CGFloat)
    {
        // Setting the angle like this sucks...
        if angle.distance(to: -CGFloat.pi * 2) == 0
        {
            invalidateTimersAndDates()
            configureInterfaceElements(state: .inactive, angle: angle)
        }
        else
        {
            setTimerToActive(angle: angle)
        }
    }
}
