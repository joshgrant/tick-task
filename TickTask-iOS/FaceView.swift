//
//  FaceView.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

#if os(iOS)
import UIKit

@IBDesignable class FaceView: UIView
{
    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()!
        
        let drawingData = DrawingData(rect: rect)
        
        Circle.faceBackgroundCircle(with: drawingData).draw(context: context)
        Circle.outerRimCircle(with: drawingData).draw(context: context)
        Circle.centerRimCircle(with: drawingData).draw(context: context)
        Circle.innerRimCircle(with: drawingData).draw(context: context)
        Circle.faceInnerCircle(with: drawingData).draw(context: context)
    }
}
#elseif os(OSX)
import AppKit

@IBDesignable class FaceView: NSView
{
    override func draw(_ rect: CGRect)
    {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        let drawingData = DrawingData(rect: rect)
        
        Circle.faceBackgroundCircle(with: drawingData).draw(context: context)
        Circle.outerRimCircle(with: drawingData).draw(context: context)
        Circle.centerRimCircle(with: drawingData).draw(context: context)
        Circle.innerRimCircle(with: drawingData).draw(context: context)
        Circle.faceInnerCircle(with: drawingData).draw(context: context)
    }
}
#endif

