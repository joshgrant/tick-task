//
//  GradientView.swift
//  TickTask-ReleaseAssets-iOS
//
//  Created by Joshua Grant on 5/29/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView
{
    var starting: Color = Color(hue: 128.0 / 360.0, saturation: 0.57, brightness: 1.0, alpha: 1.0)
    var ending: Color = Color(hue: 160.0 / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    
    @IBInspectable var startingColor: UIColor {
        get {
            return starting.color
        }
        set {
            starting = Color(color: newValue)
        }
    }
    
    @IBInspectable var endingColor: UIColor {
        get {
            return ending.color
        }
        set {
            ending = Color(color: newValue)
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let gradient = Gradient(colors: [0 : starting, 1 : ending])
        
        //// Rectangle Drawing
        let path = UIBezierPath(rect: rect)
        
        context.pushPop {
            path.addClip()
            context.drawLinearGradient(gradient.cgGradient!,
                                       start: CGPoint(x: rect.size.width, y: 0),
                                       end: CGPoint(x: 0, y: rect.size.height), options: [])
        }
    }
}
