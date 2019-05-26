//
//  DialView.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

enum DialState
{
    case inactive
    case countdown
    case selected
}

@IBDesignable class DialView: UIView
{
    @IBInspectable var angle: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()!
        
        let drawingData = DrawingData(rect: rect)
        
        let dialShape = DialShape(frame: frame, scaleFactor: drawingData.scaleFactor)
        
        dialShape.draw(context: context, angle: angle)
    }
}
