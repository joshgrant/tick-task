//
//  Shape.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

// Perhaps Circle should extend shape?

class Shape
{
    var frame: CGRect?
    
    var path: UIBezierPath
    
    var shadows: [Shadow] = []
    
    var fills: [Color] = []
    var gradients: [Gradient] = []
    
    var borders: [Border] = []
    
    init(path: UIBezierPath)
    {
        self.path = path
    }
    
    init(path: UIBezierPath, fill: Color)
    {
        self.path = path
        self.fills = [fill]
    }
    
    func draw(context: CGContext)
    {
        // TODO: pass the implementation to the drawing classes.
        // For example, shadows should draw themselves...
        drawOuterShadows(context: context)
        drawGradients(context: context)
        drawFills(context: context)
        drawInnerShadows(context: context)
        drawBorders(context: context)
    }
    
    func drawImage(frame: CGRect) -> UIImage
    {
        UIGraphicsBeginImageContext(frame.size)
        
        let context = UIGraphicsGetCurrentContext()!
        draw(context: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }

    func drawOuterShadows(context: CGContext)
    {
        for shadow in shadows
        {
            if shadow.type == .outer
            {
                shadow.draw(with: context, in: path)
            }
        }
    }

    func drawInnerShadows(context: CGContext)
    {
        for shadow in shadows
        {
            if shadow.type == .inner
            {
                shadow.draw(with: context, in: path)
            }
        }
    }
    
    func drawGradients(context: CGContext)
    {
        for gradient in gradients
        {
            gradient.draw(with: context, in: path)
        }
    }
    
    func drawFills(context: CGContext)
    {
        for fill in fills
        {
            fill.draw(with: context, in: path)
        }
    }
    
    func drawBorders(context: CGContext)
    {
        for border in borders
        {
            border.draw(with: context, in: path)
        }
    }
}
