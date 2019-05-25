//
//  DialImage.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/15/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

class DialImage
{
    var frame: CGRect
    
    var redHue: CGFloat = 0.0
    var greenHue: CGFloat = 0.35
    var yellowHue: CGFloat = 0.15
    
    var dialStrokeWidth: CGFloat = 3
    
    var fillComponents = Color(hue: 0.0, saturation: 0.043, brightness: 0.25, alpha: 0.6)
    
    var greenFill: Color {
        return Color(hue: greenHue,
                     saturation: fillComponents.saturation,
                     brightness: fillComponents.brightness,
                     alpha: fillComponents.alpha)
    }
    
    var redFill: Color {
        return Color(hue: redHue,
                     saturation: fillComponents.saturation,
                     brightness: fillComponents.brightness,
                     alpha: fillComponents.alpha)
    }
    
    var yellowFill: Color {
        return Color(hue: yellowHue,
                     saturation: fillComponents.saturation,
                     brightness: fillComponents.brightness,
                     alpha: fillComponents.alpha)
    }
    
    func dialStroke(with state: DialState) -> Color
    {
        return dialFill(with: state).colorByApplying(brightnessModification: { (brightness) -> CGFloat in
            return brightness * 0.7
        }, alphaModification: { (alpha) -> CGFloat in
            return 1.0
        })
    }
    
    func dialFill(with state: DialState) -> Color
    {
        return faceFill(with: state).colorBySetting(saturation: 0.55,
                                                    brightness: 0.7,
                                                    alpha: 1.0)
    }
    
    var dialShadowColor: Color {
        return Color(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
    }
    
    var dialInnerShadowColor: Color {
        return Color(hue: 0, saturation: 0, brightness: 1, alpha: 0.5)
    }
    
    var dialShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = dialShadowColor.uiColor
        shadow.shadowOffset = CGSize.zero
        shadow.shadowBlurRadius = 8
        return shadow
    }
    
    var dialInnerShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = dialInnerShadowColor.uiColor
        shadow.shadowOffset = CGSize(width: 0, height: dialStrokeWidth * 1.5)
        shadow.shadowBlurRadius = 0
        return shadow
    }
    
    var faceShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 0, height: 8)
        shadow.shadowBlurRadius = 16
        return shadow
    }
    
    func highlightTopGradient(fill: Color) -> CGGradient
    {
        //highlightTopGradient20aColor
        let highlightTopGradientTopColor = fill.colorByApplying(brightnessAndAlphaModification: { (value) -> CGFloat in
            return value * 0.9 + 0.1
        })
        
        //highlightTopGradient20aColor2
        let highlightTopGradientBottomColor = fill.colorByApplying(brightnessModification: { (brightness) -> CGFloat in
            return brightness * 0.9
        }, alphaModification: { (alpha) -> CGFloat in
            return alpha * 0.9 + 0.1
        })
        
        return CGGradient(colorsSpace: nil,
                          colors: [
                            highlightTopGradientTopColor.cgColor,
                            highlightTopGradientBottomColor.cgColor] as CFArray,
                          locations: [0, 1])!
    }
    
    func highlightBottomGradient(fill: Color) -> CGGradient
    {
        //highlightBottomGradient20aColor3
        let highlightBottomGradientTopColor = fill.colorByApplying(
            brightnessModification: { (brightness) -> CGFloat in
                return brightness * 0.4
        }, alphaModification: { (alpha) -> CGFloat in
            return alpha * 0.4 + 0.6
        })
        
        //highlightBottomGradient20aColor
        let highlightBottomGradientBottomColor = fill.colorByApplying(allModification: { (value) -> CGFloat in
            return value * 0.9 + 0.1
        })
        
        return CGGradient(colorsSpace: nil,
                          colors: [
                            highlightBottomGradientTopColor.cgColor,
                            highlightBottomGradientBottomColor.cgColor] as CFArray,
                          locations: [0, 1])!
    }
    
    
    func faceFill(with state: DialState) -> Color
    {
        switch state
        {
        case .inactive: return greenFill
        case .countdown: return redFill
        case .selected: return yellowFill
        }
    }
    
    init(frame: CGRect)
    {
        self.frame = frame
    }
    
    func drawFace(state: DialState)
    {
        let context = UIGraphicsGetCurrentContext()!
        
        let baseOffset: CGFloat = 5 // The offset of the ovals. Larger offset = larger borders
        let fill = faceFill(with: state)
        
        let color3 = fill.colorByApplying(brightnessModification: { (brightness) -> CGFloat in
            return brightness * 0.9 + 0.1
        }, alphaModification: { (alpha) -> CGFloat in
            return alpha * 0.9 + 0.1
        })
        
        let color = fill.colorByApplying(brightnessModification: { (brightness) -> CGFloat in
            return brightness * 0.9
        }, alphaModification: { (alpha) -> CGFloat in
            return alpha * 0.9 + 0.1
        })
        
        // We want to cache this result...
        oval5(context: context,
              targetFrame: frame,
              baseOffset: baseOffset,
              faceFill: fill.uiColor,
              faceShadow: faceShadow)
        
        oval(context: context,
             targetFrame: frame,
             baseOffset: baseOffset,
             highlightTopGradient20a: highlightTopGradient(fill: fill))
        
        oval4(targetFrame: frame,
              baseOffset: baseOffset,
              color3: color3.uiColor)
        
        oval2(context: context,
              targetFrame: frame,
              baseOffset: baseOffset,
              highlightBottomGradient20a: highlightBottomGradient(fill: fill))
        
        oval3(targetFrame: frame,
              baseOffset: baseOffset,
              color: color.uiColor)
    }
    
    
    func drawDial(angle: CGFloat, state: DialState)
    {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Rotate the context
        context.saveGState()
        context.translateBy(x: frame.width / 2, y: frame.height / 2)
        context.rotate(by: angle)
        
        let path = dial(target: frame)
        
        context.saveGState()
        
        // Outer shadow
        context.setShadow(offset: dialShadow.shadowOffset,
                          blur: dialShadow.shadowBlurRadius,
                          color: dialShadowColor.cgColor)
        
        // Fill the dial
        dialFill(with: state).uiColor.setFill()
        path.fill()
        
        // Draw the inner shadow
        
        func fillShadow()
        {
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            dialInnerShadowColor.uiColor.setFill()
            path.fill()
            context.endTransparencyLayer()
        }
        
        func shadowBlendMode()
        {
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            
            context.setShadow(offset: dialInnerShadow.shadowOffset,
                              blur: dialInnerShadow.shadowBlurRadius,
                              color: dialInnerShadowColor.colorBySetting(alpha: 1.0).cgColor)
            context.setBlendMode(.sourceOut)
            
            fillShadow()
            
            context.endTransparencyLayer()
        }
        
        context.saveGState()
        context.clip(to: path.bounds)
        
        shadowBlendMode()
        
        context.restoreGState()
        
        dialStroke(with: state).uiColor.setStroke()
        path.lineWidth = dialStrokeWidth
        path.stroke()
        
        context.restoreGState()
        
        context.restoreGState()
    }
    
    func oval(target: CGRect, baseOffset: CGFloat, level: CGFloat) -> UIBezierPath
    {
        let shadowSize = (faceShadow.shadowBlurRadius / 2) + faceShadow.shadowOffset.height
        
        let x = baseOffset * level + shadowSize
        let y = baseOffset * level + shadowSize
        let w = target.size.width - x * 2
        let h = target.size.height - y * 2
        
        return UIBezierPath(ovalIn: CGRect(x: x, y: y, width: w, height: h))
    }
    
    func oval5(context: CGContext, targetFrame: CGRect, baseOffset: CGFloat, faceFill: UIColor, faceShadow: NSShadow)
    {
        let oval5Path = oval(target: targetFrame, baseOffset: baseOffset, level: 1)
        context.saveGState()
        
        context.setShadow(offset: CGSize(width: faceShadow.shadowOffset.width,
                                         height: faceShadow.shadowOffset.height),
                          blur: faceShadow.shadowBlurRadius,
                          color: (faceShadow.shadowColor as! UIColor).cgColor)
        
        faceFill.setFill()
        oval5Path.fill()
        context.restoreGState()
        
        UIColor(white: 1.0, alpha: 0.2).setStroke()
        oval5Path.lineWidth = 1
        oval5Path.stroke()
    }
    
    func oval(context: CGContext, targetFrame: CGRect, baseOffset: CGFloat, highlightTopGradient20a: CGGradient)
    {
        let ovalPath = oval(target: targetFrame, baseOffset: baseOffset, level: 1)
        context.saveGState()
        ovalPath.addClip()
        context.drawLinearGradient(highlightTopGradient20a,
                                   start: CGPoint(x: targetFrame.size.width / 2,
                                                  y: 0),
                                   end: CGPoint(x: targetFrame.size.width / 2,
                                                y: targetFrame.size.height),
                                   options: [])
        context.restoreGState()
    }
    
    func oval4(targetFrame: CGRect, baseOffset: CGFloat, color3: UIColor)
    {
        let oval4Path = oval(target: targetFrame, baseOffset: baseOffset, level: 2)
        color3.setFill()
        oval4Path.fill()
    }
    
    func oval2(context: CGContext, targetFrame: CGRect, baseOffset: CGFloat, highlightBottomGradient20a: CGGradient)
    {
        
        let oval2Path = oval(target: targetFrame, baseOffset: baseOffset, level: 3)
        context.saveGState()
        oval2Path.addClip()
        context.drawLinearGradient(highlightBottomGradient20a,
                                   start: CGPoint(x: targetFrame.size.width / 2,
                                                  y: targetFrame.origin.y),
                                   end: CGPoint(x: targetFrame.size.width / 2,
                                                y: targetFrame.size.height), options: [])
        context.restoreGState()
    }
    
    func oval3(targetFrame: CGRect, baseOffset: CGFloat, color: UIColor)
    {
        let oval3Path = oval(target: targetFrame, baseOffset: baseOffset, level: 4)
        color.setFill()
        oval3Path.fill()
    }
    //
    func dial(target: CGRect) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        let size = target.size.width - (faceShadow.shadowOffset.height + faceShadow.shadowBlurRadius / 2) * 2
        
        let innerCircleRadius: CGFloat = size * 0.039
        let dialLength: CGFloat = size * 0.37
        let bodyRadius: CGFloat = size * 0.09
        let tipRadius: CGFloat = size *  0.03
        
        let bodyCenter = CGPoint.zero
        let tipCenter = CGPoint(x: 0, y: -dialLength)
        
        let distanceCenters = bodyCenter.distance(to: tipCenter)
        let differenceRadius = (bodyRadius - tipRadius)
        
        // We use the pythagorean theorem to find the third side of a right triangle
        // a^2 + b^2 = c^2
        // In this case, we have a^2 and c^2 but not b^2
        let distanceTangents = (distanceCenters.squared - differenceRadius.squared).squareRoot()
        
        // Now we use the law of sines to find the angle that the tangent is from the center of the circle
        let theta = asin(distanceTangents / distanceCenters)
        
        // We have to get the angle that is 90° - theta
        let thetaComplement = (CGFloat.pi / 2) - theta
        
        // Move to the top of the dial
        
        let bodyRight = CGPoint(x: bodyCenter.x + bodyRadius * cos(thetaComplement),
                                y: bodyCenter.y - bodyRadius * sin(thetaComplement))
        
        path.addArc(withCenter: CGPoint.zero,
                    radius: innerCircleRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: false)
        
        path.close()
        
        path.move(to: bodyRight)
        
        path.addArc(withCenter: bodyCenter,
                    radius: bodyRadius,
                    startAngle: -thetaComplement,
                    endAngle: CGFloat.pi + thetaComplement,
                    clockwise: true)
        path.addArc(withCenter: tipCenter,
                    radius: tipRadius,
                    startAngle: CGFloat.pi + thetaComplement, endAngle: -thetaComplement, clockwise: true)
        path.close()
        
        return path
    }
    
    //// Generated Images
    
//    func imageOfTickTask(angle: CGFloat, size: CGSize, state: DialState) -> UIImage
//    {
//        let color: String
//
//        switch state
//        {
//        case .countdown:
//            color = "red"
//        case .inactive:
//            color = "green"
//        case .selected:
//            color = "yellow"
//        }
//
//        // We only want to save the images when the user is modifying the dial image,
//        // because otherwise the app would take a huge amount of space...
//        if let cachedImage = loadCachedImage(state: state, angle: angle, color: color)
//        {
//            return cachedImage
//        }
//        else
//        {
//            UIGraphicsBeginImageContextWithOptions(size, false, 0)
//
//            // Maybe we should have two image views, or something, for faster loading...
//            drawFace(state: state)
//            drawDial(angle: angle, state: state)
//
//            let imageOfTickTask = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//
//            cacheImage(state: state, angle: angle, imageData: imageOfTickTask.pngData(), color: color)
//
//            return imageOfTickTask
//        }
//    }
    
    func dialImage(angle: CGFloat, state: DialState) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        drawDial(angle: angle, state: state)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func faceImage(state: DialState) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)

        drawFace(state: state)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }
}
