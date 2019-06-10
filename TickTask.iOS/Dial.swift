//
//  Dial.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 6/10/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

class Dial: UIControl
{
    var delegate: DialDelegate?
    var dialState: DialState = .inactive
    
    var doubleValue: Double = 0
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
    {
        let point = touch.location(in: self)
        doubleValue = secondsFrom(point: point, in: self)
        
        delegate?.dialStartedTracking(dial: self)
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
    {
        let point = touch.location(in: self)
        doubleValue = secondsFrom(point: point, in: self)
        
        delegate?.dialUpdatedTracking(dial: self)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?)
    {
        if let point = touch?.location(in: self)
        {
            doubleValue = secondsFrom(point: point, in: self)
        }
        
        delegate?.dialStoppedTracking(dial: self)
    }
    
    override func draw(_ rect: CGRect)
    {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let drawingData = DrawingData(rect: rect)
        
        let dialShape = DialShape(drawingData: drawingData)
        
        dialShape.draw(context: context, angle: CGFloat(doubleValue.toAngle()), state: dialState)
    }
    
    func secondsFrom(point: CGPoint, in view: UIView, snap: Bool = true) -> Double
    {
        let center = view.frame.center
        let distance = point.distance(to: center)
        let angle = Double(point.angleFromPoint(point: center))
        let seconds = angle.toSeconds()
        
        var snapValue: Double = seconds
        
        if snap
        {
            if distance <= view.frame.size.width / 3
            {
                // Snap to 5 minute intervals
                snapValue = seconds - seconds.remainder(dividingBy: 300)
            }
            else
            {
                // Snap to 1 minute intervals
                snapValue = seconds - seconds.remainder(dividingBy: 60)
            }
        }
        
        return Double(snapValue)
    }
}
