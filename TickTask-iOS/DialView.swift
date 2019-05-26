//
//  DialView.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

@IBDesignable class DialView: UIView
{
    @IBInspectable var angle: CGFloat = 0
    
    var state: DialState = .inactive
    
    override func draw(_ rect: CGRect)
    {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let drawingData = DrawingData(rect: rect)
        
        let dialShape = DialShape(frame: frame, scaleFactor: drawingData.scaleFactor)
        
        dialShape.draw(context: context, angle: angle, state: state)
    }
}
