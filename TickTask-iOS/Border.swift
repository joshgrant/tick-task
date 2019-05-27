//
//  Border.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreGraphics

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
        return Border(width: 1 * scaleFactor, color: Color(brightness: 1, alpha: 0.1), type: .inner)
    }
    
    static func faceOuterBorder(with scaleFactor: CGFloat) -> Border
    {
        return Border(width: 0.5 * scaleFactor, color: Color(brightness: 1, alpha: 0.2), type: .center)
    }
    
    func draw(with context: CGContext, in path: Path)
    {
        context.pushPop {
            path.lineWidth = width
            
            context.beginPath()
            context.addPath(path.cgPath)
            
            switch type
            {
            case .outer:
                context.addRect(path.bounds.insetBy(dx: -width * 2, dy: -width * 2))
            case .center:
                context.addRect(path.bounds.insetBy(dx: -width, dy: -width))
            default:
                break
            }
            
            context.clip(using: .evenOdd)
            color.setStroke()
            path.stroke()
        }
    }
}
