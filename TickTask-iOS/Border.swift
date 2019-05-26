//
//  Border.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

enum BorderType
{
    case outer
    case inner
    case center
}

struct Border
{
    var width: CGFloat
    var color: Color
    var type: BorderType
    
    static func dialOuterBorder(with scaleFactor: CGFloat) -> Border
    {
        return Border(width: 1 * scaleFactor, color: Color(brightness: 0, alpha: 0.4), type: .outer)
    }
    
    static func dialInnerBorder(with scaleFactor: CGFloat) -> Border
    {
        return Border(width: 1 * scaleFactor, color: Color(brightness: 1, alpha: 0.2), type: .inner)
    }
    
    static func faceOuterBorder(with scaleFactor: CGFloat) -> Border
    {
        return Border(width: 0.5 * scaleFactor, color: Color(brightness: 1, alpha: 0.3), type: .center)
    }
    
    func draw(with context: CGContext, in path: UIBezierPath)
    {
        context.pushPop {
            path.lineWidth = width
            
            context.beginPath()
            context.addPath(path.cgPath)
            
            switch type
            {
            case .outer:
                context.addRect(path.bounds.insetBy(dx: -path.lineWidth * 2, dy: -path.lineWidth * 2))
            case .center:
                context.addRect(path.bounds.insetBy(dx: -path.lineWidth, dy: -path.lineWidth))
            default:
                break
            }
            
            context.clip(using: .evenOdd)
            color.uiColor.setStroke()
            path.stroke()
        }
    }
}
