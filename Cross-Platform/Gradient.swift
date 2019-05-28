//
//  Gradient.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreGraphics

struct Gradient
{
    var colors: [CGFloat: Color]
    
    var cgGradient: CGGradient? {
        
        var locations: [CGFloat] = []
        var cgColors: [CGColor] = []
        
        for (location, color) in colors
        {
            locations.append(location)
            cgColors.append(color.cgColor)
        }
        
        return CGGradient(colorsSpace: nil, colors: cgColors as CFArray, locations: locations)
    }
    
    static var outerRimGradient: Gradient {
        return Gradient(colors: [
            0 : Color.outerRimGradientHighlight,
            1 : Color.outerRimGradientShadow])
    }
    
    static var innerRimGradient: Gradient {
        return Gradient(colors: [
            0 : Color.innerRimGradientShadow,
            1 : Color.innerRimGradientHighlight])
    }
    
    // MARK: Drawing
    
    func draw(with context: CGContext, in path: Path)
    {
        if let cgGradient = cgGradient
        {
            context.pushPop {
                path.addClip()
                context.drawLinearGradient(cgGradient,
                                           start: CGPoint(x: path.bounds.origin.x + path.bounds.size.width / 2,
                                                          y: path.bounds.origin.y),
                                           end: CGPoint(x: path.bounds.origin.x + path.bounds.size.width / 2,
                                                        y: path.bounds.origin.y + path.bounds.size.height),
                                           options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
            }
        }
    }
}
