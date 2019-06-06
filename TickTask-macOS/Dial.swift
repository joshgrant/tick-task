//
//  Dial.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/4/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

protocol DialDelegate
{
    func dialStartedTracking(dial: Dial)
    func dialStoppedTracking(dial: Dial)
    func dialUpdatedTracking(dial: Dial)
}

class Dial: NSSliderCell
{
    var delegate: DialDelegate?
    
    // We want to set the state manually, so we override this method. Maybe we'll
    // come in here sometime and implement better state setting methods?
    override func setNextState() {}
    
    override func startTracking(at startPoint: NSPoint, in controlView: NSView) -> Bool
    {
        doubleValue = secondsFrom(point: startPoint, in: controlView)
        
        delegate?.dialStartedTracking(dial: self)
        
        return true
    }
    
    override func continueTracking(last lastPoint: NSPoint, current currentPoint: NSPoint, in controlView: NSView) -> Bool
    {
        doubleValue = secondsFrom(point: currentPoint, in: controlView)
        
        delegate?.dialUpdatedTracking(dial: self)
        
        return true
    }
    
    override func stopTracking(last lastPoint: NSPoint, current stopPoint: NSPoint, in controlView: NSView, mouseIsUp flag: Bool)
    {
        doubleValue = secondsFrom(point: stopPoint, in: controlView)
        
        delegate?.dialStoppedTracking(dial: self)
    }
    
    func secondsFrom(point: NSPoint, in view: NSView) -> Double
    {
        let center = view.frame.center
        let angle = Double(point.angleFromPoint(point: center))
        let minutes = angle.toSeconds()
        return Double(minutes)
    }
    
    override func knobRect(flipped: Bool) -> NSRect
    {
        return barRect(flipped: flipped)
    }
    
    override func drawKnob(_ knobRect: NSRect)
    {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        let drawingData = DrawingData(rect: knobRect)
        
        context.pushPop {
            let dialShape = DialShape(drawingData: drawingData)
            
            dialShape.draw(context: context, angle: CGFloat(doubleValue.toAngle()), state: state)
        }
    }
    
    override func barRect(flipped: Bool) -> NSRect
    {
        let size = self.controlView!.bounds
        let smaller = size.width > size.height ? size.height : size.width
        
        return NSRect(origin: CGPoint.zero, size: CGSize(square: smaller))
    }
    
    override func drawBar(inside rect: NSRect, flipped: Bool)
    {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        let drawingData = DrawingData(rect: rect)
        
        context.pushPop {
            Circle.faceBackgroundCircle(with: drawingData).draw(context: context)
            Circle.outerRimCircle(with: drawingData).draw(context: context)
            Circle.centerRimCircle(with: drawingData).draw(context: context)
            Circle.innerRimCircle(with: drawingData).draw(context: context)
            Circle.faceInnerCircle(with: drawingData).draw(context: context)
        }
    }
    
    override func drawTickMarks() {}
}
