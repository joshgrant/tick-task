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
    
    func secondsFrom(point: CGPoint, in view: UIView) -> Double
    {
        let center = view.frame.center
        let angle = Double(point.angleFromPoint(point: center))
        let minutes = angle.toSeconds()
        return Double(minutes)
    }
}
