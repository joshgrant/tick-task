//
//  FaceView.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/27/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

@IBDesignable class FaceView: NSView
{
    override func draw(_ rect: CGRect)
    {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        let drawingData = DrawingData(rect: rect)
        
        context.pushPop {
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1, y: -1)
            
            Circle.faceBackgroundCircle(with: drawingData).draw(context: context)
            Circle.outerRimCircle(with: drawingData).draw(context: context)
            Circle.centerRimCircle(with: drawingData).draw(context: context)
            Circle.innerRimCircle(with: drawingData).draw(context: context)
            Circle.faceInnerCircle(with: drawingData).draw(context: context)
        }
    }
}
