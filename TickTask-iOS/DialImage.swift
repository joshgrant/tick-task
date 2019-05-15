//
//  DialImage.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/15/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

enum DialState
{
    case inactive
    case countdown
    case selected
}

public class DialImage : NSObject {
    
    //// Drawing Methods
    
    static func drawTickTask(frame targetFrame: CGRect, resizing: ResizingBehavior, angle: CGFloat, state: DialState) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 110, height: 110), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 110, y: resizedFrame.height / 110)
        let resizedShadowScale: CGFloat = min(resizedFrame.width / 110, resizedFrame.height / 110)
        
        let faceFill: UIColor
        
        switch state {
        case .inactive:
            faceFill = UIColor(hue: 0.35, saturation: 0.043, brightness: 0.25, alpha: 0.6)
        case .countdown:
            faceFill = UIColor(hue: 0.0, saturation: 0.043, brightness: 0.25, alpha: 0.6)
        case .selected:
            faceFill = UIColor(hue: 0.15, saturation: 0.043, brightness: 0.25, alpha: 0.6)
        }
        
        //// Color Declarations
        let white20a = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.200)
        //        let faceFill = UIColor(red: 0.250, green: 0.249, blue: 0.239, alpha: 0.600)
        var faceFillRedComponent: CGFloat = 1
        var faceFillGreenComponent: CGFloat = 1
        var faceFillBlueComponent: CGFloat = 1
        faceFill.getRed(&faceFillRedComponent, green: &faceFillGreenComponent, blue: &faceFillBlueComponent, alpha: nil)
        
        var faceFillHueComponent: CGFloat = 1
        var faceFillSaturationComponent: CGFloat = 1
        var faceFillBrightnessComponent: CGFloat = 1
        faceFill.getHue(&faceFillHueComponent, saturation: &faceFillSaturationComponent, brightness: &faceFillBrightnessComponent, alpha: nil)
        
        let highlightTopGradient20aColor = UIColor(red: (faceFillRedComponent * 0.9 + 0.1), green: (faceFillGreenComponent * 0.9 + 0.1), blue: (faceFillBlueComponent * 0.9 + 0.1), alpha: (faceFill.cgColor.alpha * 0.9 + 0.1))
        let highlightTopGradient20aColor2 = UIColor(red: (faceFillRedComponent * 0.9), green: (faceFillGreenComponent * 0.9), blue: (faceFillBlueComponent * 0.9), alpha: (faceFill.cgColor.alpha * 0.9 + 0.1))
        let highlightBottomGradient20aColor = UIColor(red: (faceFillRedComponent * 0.9 + 0.1), green: (faceFillGreenComponent * 0.9 + 0.1), blue: (faceFillBlueComponent * 0.9 + 0.1), alpha: (faceFill.cgColor.alpha * 0.9 + 0.1))
        let highlightBottomGradient20aColor3 = UIColor(red: (faceFillRedComponent * 0.4), green: (faceFillGreenComponent * 0.4), blue: (faceFillBlueComponent * 0.4), alpha: (faceFill.cgColor.alpha * 0.4 + 0.6))
        let color = UIColor(red: (faceFillRedComponent * 0.9), green: (faceFillGreenComponent * 0.9), blue: (faceFillBlueComponent * 0.9), alpha: (faceFill.cgColor.alpha * 0.9 + 0.1))
        let baseDial = UIColor(hue: faceFillHueComponent, saturation: faceFillSaturationComponent, brightness: 0.8, alpha: faceFill.cgColor.alpha)
        let baseDial2 = baseDial.withAlphaComponent(1)
        var baseDial2HueComponent: CGFloat = 1
        var baseDial2SaturationComponent: CGFloat = 1
        var baseDial2BrightnessComponent: CGFloat = 1
        baseDial2.getHue(&baseDial2HueComponent, saturation: &baseDial2SaturationComponent, brightness: &baseDial2BrightnessComponent, alpha: nil)
        
        let baseDial3 = UIColor(hue: baseDial2HueComponent, saturation: 0.5, brightness: baseDial2BrightnessComponent, alpha: baseDial2.cgColor.alpha)
        var baseDial3RedComponent: CGFloat = 1
        var baseDial3GreenComponent: CGFloat = 1
        var baseDial3BlueComponent: CGFloat = 1
        baseDial3.getRed(&baseDial3RedComponent, green: &baseDial3GreenComponent, blue: &baseDial3BlueComponent, alpha: nil)
        
        let baseDial4 = UIColor(red: (baseDial3RedComponent * 0.7), green: (baseDial3GreenComponent * 0.7), blue: (baseDial3BlueComponent * 0.7), alpha: (baseDial3.cgColor.alpha * 0.7 + 0.3))
        let color3 = UIColor(red: (faceFillRedComponent * 0.9 + 0.1), green: (faceFillGreenComponent * 0.9 + 0.1), blue: (faceFillBlueComponent * 0.9 + 0.1), alpha: (faceFill.cgColor.alpha * 0.9 + 0.1))
        let dialInnerShadowColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.500)
        let faceBackgroundShadow = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        //// Gradient Declarations
        let highlightTopGradient20a = CGGradient(colorsSpace: nil, colors: [highlightTopGradient20aColor.cgColor, highlightTopGradient20aColor2.cgColor] as CFArray, locations: [0, 1])!
        let highlightBottomGradient20a = CGGradient(colorsSpace: nil, colors: [highlightBottomGradient20aColor3.cgColor, highlightBottomGradient20aColor.cgColor] as CFArray, locations: [0, 1])!
        
        //// Shadow Declarations
        let dialShadow = NSShadow()
        dialShadow.shadowColor = UIColor.black.withAlphaComponent(0.5)
        dialShadow.shadowOffset = CGSize(width: 0, height: 0)
        dialShadow.shadowBlurRadius = 4
        let dialInnerShadow = NSShadow()
        dialInnerShadow.shadowColor = dialInnerShadowColor
        dialInnerShadow.shadowOffset = CGSize(width: 0, height: 2)
        dialInnerShadow.shadowBlurRadius = 0
        let faceShadow = NSShadow()
        faceShadow.shadowColor = faceBackgroundShadow
        faceShadow.shadowOffset = CGSize(width: 0, height: 2)
        faceShadow.shadowBlurRadius = 4
        
        //// Oval 5 Drawing
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: 5, y: 3, width: 100, height: 100))
        context.saveGState()
        context.setShadow(offset: CGSize(width: faceShadow.shadowOffset.width * resizedShadowScale, height: faceShadow.shadowOffset.height * resizedShadowScale), blur: faceShadow.shadowBlurRadius * resizedShadowScale, color: (faceShadow.shadowColor as! UIColor).cgColor)
        faceFill.setFill()
        oval5Path.fill()
        context.restoreGState()
        
        white20a.setStroke()
        oval5Path.lineWidth = 1
        oval5Path.stroke()
        
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 5, y: 3, width: 100, height: 100))
        context.saveGState()
        ovalPath.addClip()
        context.drawLinearGradient(highlightTopGradient20a, start: CGPoint(x: 55, y: 3), end: CGPoint(x: 55, y: 103), options: [])
        context.restoreGState()
        
        
        //// Oval 4 Drawing
        let oval4Path = UIBezierPath(ovalIn: CGRect(x: 7, y: 5, width: 96, height: 96))
        color3.setFill()
        oval4Path.fill()
        
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 9, y: 7, width: 92, height: 92))
        context.saveGState()
        oval2Path.addClip()
        context.drawLinearGradient(highlightBottomGradient20a, start: CGPoint(x: 55, y: 7), end: CGPoint(x: 55, y: 99), options: [])
        context.restoreGState()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: 11, y: 9, width: 88, height: 88))
        color.setFill()
        oval3Path.fill()
        
        
        //// Bezier 2 Drawing
        context.saveGState()
        context.translateBy(x: 55, y: 53)
        context.rotate(by: angle)
        
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 0, y: -4.05))
        bezier2Path.addCurve(to: CGPoint(x: -4.22, y: 0.12), controlPoint1: CGPoint(x: -2.33, y: -4.05), controlPoint2: CGPoint(x: -4.22, y: -2.19))
        bezier2Path.addCurve(to: CGPoint(x: 0, y: 4.29), controlPoint1: CGPoint(x: -4.22, y: 2.42), controlPoint2: CGPoint(x: -2.33, y: 4.29))
        bezier2Path.addLine(to: CGPoint(x: 0.06, y: 4.29))
        bezier2Path.addCurve(to: CGPoint(x: 4.22, y: 0.12), controlPoint1: CGPoint(x: 2.36, y: 4.26), controlPoint2: CGPoint(x: 4.22, y: 2.4))
        bezier2Path.addCurve(to: CGPoint(x: 0, y: -4.05), controlPoint1: CGPoint(x: 4.22, y: -2.19), controlPoint2: CGPoint(x: 2.33, y: -4.05))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: 2.87, y: -37.1))
        bezier2Path.addCurve(to: CGPoint(x: 9.33, y: -1.72), controlPoint1: CGPoint(x: 3.22, y: -35.68), controlPoint2: CGPoint(x: 9.33, y: -1.72))
        bezier2Path.addCurve(to: CGPoint(x: 0, y: 9.5), controlPoint1: CGPoint(x: 10.47, y: 4.59), controlPoint2: CGPoint(x: 5.7, y: 9.5))
        bezier2Path.addCurve(to: CGPoint(x: -9.33, y: -1.72), controlPoint1: CGPoint(x: -5.69, y: 9.5), controlPoint2: CGPoint(x: -10.47, y: 4.59))
        bezier2Path.addCurve(to: CGPoint(x: -2.87, y: -37.1), controlPoint1: CGPoint(x: -9.33, y: -1.72), controlPoint2: CGPoint(x: -3.06, y: -36.33))
        bezier2Path.addCurve(to: CGPoint(x: 0, y: -39.5), controlPoint1: CGPoint(x: -2.52, y: -38.52), controlPoint2: CGPoint(x: -1.47, y: -39.5))
        bezier2Path.addCurve(to: CGPoint(x: 2.87, y: -37.1), controlPoint1: CGPoint(x: 1.47, y: -39.5), controlPoint2: CGPoint(x: 2.52, y: -38.52))
        bezier2Path.close()
        context.saveGState()
        context.setShadow(offset: CGSize(width: dialShadow.shadowOffset.width * resizedShadowScale, height: dialShadow.shadowOffset.height * resizedShadowScale), blur: dialShadow.shadowBlurRadius * resizedShadowScale, color: (dialShadow.shadowColor as! UIColor).cgColor)
        baseDial3.setFill()
        bezier2Path.fill()
        
        ////// Bezier 2 Inner Shadow
        context.saveGState()
        context.clip(to: bezier2Path.bounds)
        context.setShadow(offset: CGSize.zero, blur: 0)
        context.setAlpha((dialInnerShadow.shadowColor as! UIColor).cgColor.alpha)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let bezier2OpaqueShadow = (dialInnerShadow.shadowColor as! UIColor).withAlphaComponent(1)
        context.setShadow(offset: CGSize(width: dialInnerShadow.shadowOffset.width * resizedShadowScale, height: dialInnerShadow.shadowOffset.height * resizedShadowScale), blur: dialInnerShadow.shadowBlurRadius * resizedShadowScale, color: bezier2OpaqueShadow.cgColor)
        context.setBlendMode(.sourceOut)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        bezier2OpaqueShadow.setFill()
        bezier2Path.fill()
        
        context.endTransparencyLayer()
        context.endTransparencyLayer()
        context.restoreGState()
        
        context.restoreGState()
        
        baseDial4.setStroke()
        bezier2Path.lineWidth = 1
        bezier2Path.stroke()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    //// Generated Images
    
    static func imageOfTickTask(angle: CGFloat, size: CGSize, state: DialState) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        //        DialImage.drawTickTask(angle: angle)
        DialImage.drawTickTask(frame: CGRect(origin: CGPoint.zero, size: size), resizing: .aspectFit, angle: angle, state: state)
        
        let imageOfTickTask = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return imageOfTickTask
    }
    
    @objc(DialImageResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
