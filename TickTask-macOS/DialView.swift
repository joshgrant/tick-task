//
//  ImageView.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/9/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//
import Cocoa

protocol DialViewDelegate
{
    func dialViewAngleDurationUpdate(angle: CGFloat)
}

@IBDesignable class DialView: NSView
{
    @IBInspectable var duration: CGFloat {
        get {
            return CGFloat(angle.toInterval() / 60.0)
        }
        set {
            angle = TimeInterval(newValue * 60.0).toAngle()
        }
    }
    
    @IBInspectable var dialState: Int {
        get {
            return state.rawValue
        }
        set {
            state = DialState(rawValue: newValue) ?? .inactive
        }
    }
    
    var angle: CGFloat = 0 {
        didSet {
            delegate?.dialViewAngleDurationUpdate(angle: angle)
        }
    }
    
    var delegate: DialViewDelegate?
    var state: DialState = .inactive
    
    override func draw(_ rect: CGRect)
    {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        let drawingData = DrawingData(rect: rect)
        
        context.pushPop {
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1, y: -1)
            
            let dialShape = DialShape(drawingData: drawingData)
            
            dialShape.draw(context: context, angle: angle, state: state)
        }
    }
}
