//
//  Shadow.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreGraphics

enum ShadowType
{
    case inner
    case outer
}

struct Shadow
{
    var color: Color
    var blur: CGFloat
    var spread: CGFloat // Right now, spread does nothing...
    var offset: CGSize
    var type: ShadowType
    
    static func faceDropShadow(with scaleFactor: CGFloat) -> Shadow
    {
        return Shadow(color: Color.faceDropShadow,
                      blur: 4 * scaleFactor,
                      spread: 0,
                      offset: CGSize(width: 0, height: 2 * scaleFactor),
                      type: .outer)
    }
    
    static func dialOuterDropShadow(with scaleFactor: CGFloat) -> Shadow
    {
        return Shadow(color: Color.dialOuterDropShadow,
                      blur: 4 * scaleFactor,
                      spread: 0,
                      offset: CGSize(width: 0, height: 2 * scaleFactor),
                      type: .outer)
    }
    
    static func dialOuterStrokeShadow(with scaleFactor: CGFloat) -> Shadow
    {
        return Shadow(color: Color.dialOuterStrokeShadow,
                      blur: 2 * scaleFactor,
                      spread: 0,
                      offset: CGSize(width: 0, height: 1 * scaleFactor),
                      type: .outer)
    }
    
    static func dialInnerHighlight(with scaleFactor: CGFloat) -> Shadow
    {
        return Shadow(color: Color.dialInnerHighlight,
                      blur: 0,
                      spread: 0,
                      offset: CGSize(width: 0, height: 0.5 * scaleFactor),
                      type: .inner)
    }
    
    static func dialInnerShadow(with scaleFactor: CGFloat) -> Shadow
    {
        return Shadow(color: Color.dialInnerShadow,
                      blur: 0,
                      spread: 0,
                      offset: CGSize(width: 0, height: -0.5 * scaleFactor),
                      type: .inner)
    }
    
    // MARK: Drawing
    
    func draw(with context: CGContext, in path: Path)
    {
        switch type
        {
        case .outer:
            drawOuterShadow(with: context, in: path)
        case .inner:
            drawInnerShadow(with: context, in: path)
        }
    }
    
    fileprivate func drawOuterShadow(with context: CGContext, in path: Path)
    {
        context.pushPop {
            context.setShadow(shadow: self)
            color.setFill()
            path.fill()
        }
    }
    
    fileprivate func drawInnerShadow(with context: CGContext, in path: Path)
    {
        context.pushPop {
            context.clip(to: path.bounds)
            context.setShadow(offset: CGSize.zero, blur: 0)
            context.setAlpha(color.cgColor.alpha)
            context.pushPopTransparency() {
                let opaqueShadow = color.colorBySetting(alpha: 1.0)
                context.setShadow(offset: offset,
                                  blur: blur,
                                  color: opaqueShadow.cgColor)
                context.setBlendMode(.sourceOut)
                context.pushPopTransparency() {
                    opaqueShadow.setFill()
                    path.fill()
                }
            }
        }
    }
}
