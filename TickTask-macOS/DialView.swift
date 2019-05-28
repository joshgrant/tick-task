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
    func dialViewMouseEvent(_ event: NSEvent)
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
            delegate?.dialViewAngleDurationUpdate(angle: angle)
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
    
    var angle: CGFloat = 0
    var state: DialState = .inactive
    
    var delegate: DialViewDelegate?
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { return true }
    override var acceptsFirstResponder: Bool { return true }
    override func mouseUp(with event: NSEvent) { delegate?.dialViewMouseEvent(event) }
    override func mouseDragged(with event: NSEvent) { delegate?.dialViewMouseEvent(event) }
    override func mouseDown(with event: NSEvent) { delegate?.dialViewMouseEvent(event) }
    override func rightMouseDown(with event: NSEvent) { delegate?.dialViewMouseEvent(event) }
    override func rightMouseDragged(with event: NSEvent) { delegate?.dialViewMouseEvent(event) }
    override func rightMouseUp(with event: NSEvent) { delegate?.dialViewMouseEvent(event) }
    
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
