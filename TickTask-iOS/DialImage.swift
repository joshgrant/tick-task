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

struct BezierPoint
{
    var endPoint: CGPoint
    var controlLeft: CGPoint
    var controlRight: CGPoint
}

extension UIBezierPath
{
    func addCurve(to point: BezierPoint)
    {
        self.addCurve(to: point.endPoint,
                      controlPoint1: point.controlLeft,
                      controlPoint2: point.controlRight)
    }
}

// TODO: Render the background as an image and only display the dial...
// This will save some computation time...

public class DialImage : NSObject {
    
    //// Drawing Methods
    
    static func drawTickTask(frame targetFrame: CGRect, angle: CGFloat, state: DialState) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        
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
        
        /// MARK: VALUE
        let baseOffset: CGFloat = 5
        
        func oval(target: CGRect, baseOffset: CGFloat, level: CGFloat) -> UIBezierPath
        {
            let origin = CGPoint(x: (baseOffset + 1) * level, y: baseOffset * level)
            let size = CGSize(width: target.size.width - origin.x * 2, height: target.size.height - origin.y * 2)
            return UIBezierPath(ovalIn: CGRect(origin: origin, size: size))
        }
        
        //// Oval 5 Drawing
        
        let oval5Path = oval(target: targetFrame, baseOffset: baseOffset, level: 1)
        
        context.saveGState()
        context.setShadow(offset: CGSize(width: faceShadow.shadowOffset.width, height: faceShadow.shadowOffset.height), blur: faceShadow.shadowBlurRadius, color: (faceShadow.shadowColor as! UIColor).cgColor)
        faceFill.setFill()
        oval5Path.fill()
        context.restoreGState()
        
        white20a.setStroke()
        oval5Path.lineWidth = 1
        oval5Path.stroke()
        
        //// Oval Drawing
        let ovalPath = oval(target: targetFrame, baseOffset: baseOffset, level: 1)
        context.saveGState()
        ovalPath.addClip()
        context.drawLinearGradient(highlightTopGradient20a, start: CGPoint(x: targetFrame.size.width / 2, y: 0), end: CGPoint(x: targetFrame.size.width / 2, y: targetFrame.size.height), options: [])
        context.restoreGState()
        
        
        //// Oval 4 Drawing
        let oval4Path = oval(target: targetFrame, baseOffset: baseOffset, level: 2)
        color3.setFill()
        oval4Path.fill()
        
        
        //// Oval 2 Drawing
        let oval2Path = oval(target: targetFrame, baseOffset: baseOffset, level: 3)
        context.saveGState()
        oval2Path.addClip()
        context.drawLinearGradient(highlightBottomGradient20a,
                                   start: CGPoint(x: targetFrame.size.width / 2,
                                                  y: targetFrame.origin.y),
                                   end: CGPoint(x: targetFrame.size.width / 2,
                                                y: targetFrame.size.height), options: [])
        context.restoreGState()
        
        
        //// Oval 3 Drawing
        let oval3Path = oval(target: targetFrame, baseOffset: baseOffset, level: 4)
        color.setFill()
        oval3Path.fill()
        
        
        //// Bezier 2 Drawing
        context.saveGState()
        // The base offset is to consider the shadow...
        context.translateBy(x: targetFrame.width / 2, y: targetFrame.height / 2 - baseOffset)
        context.rotate(by: angle)
        
        let bezier2Path = dial(target: targetFrame)
        context.saveGState()
        context.setShadow(offset: CGSize(width: dialShadow.shadowOffset.width,
                                         height: dialShadow.shadowOffset.height),
                          blur: dialShadow.shadowBlurRadius,
                          color: (dialShadow.shadowColor as! UIColor).cgColor)
        baseDial3.setFill()
        bezier2Path.fill()
        
        ////// Bezier 2 Inner Shadow
        context.saveGState()
        context.clip(to: bezier2Path.bounds)
        context.setShadow(offset: CGSize.zero, blur: 0)
        context.setAlpha((dialInnerShadow.shadowColor as! UIColor).cgColor.alpha)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let bezier2OpaqueShadow = (dialInnerShadow.shadowColor as! UIColor).withAlphaComponent(1)
        context.setShadow(offset: CGSize(width: dialInnerShadow.shadowOffset.width,
                                         height: dialInnerShadow.shadowOffset.height),
                          blur: dialInnerShadow.shadowBlurRadius,
                          color: bezier2OpaqueShadow.cgColor)
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
    
    static func dial(target: CGRect) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        let radius: CGFloat = 10
        
        // Taken from http://spencermortensen.com/articles/bezier-circle/
        let controlPointFactor: CGFloat = 0.55191502449
        
        let controlOffset = radius * controlPointFactor
        
        let innerPoints = innerCircle(radius: radius, controlOffset: controlOffset)
        
        // We start at the top of the circle
        path.move(to: CGPoint(x: 0, y: -radius))
        
        path.addCurve(to: innerPoints.right)
        path.addCurve(to: innerPoints.bottom)
        path.addCurve(to: innerPoints.left)
        path.addCurve(to: innerPoints.top)
        
        path.close()
        
        // NEGATIVE Y == UPWARDS
        
        let dialLength: CGFloat = 120
        let bodyRadius: CGFloat = 30
        let tipRadius: CGFloat = 10
        
        let curvePoints = outerDial(bodyCenter: CGPoint.zero,
                                    bodyRadius: bodyRadius,
                                    tipCenter: CGPoint(x: 0, y: -dialLength),
                                    tipRadius: tipRadius)
        
        // Move to the top of the dial
        path.move(to: curvePoints.tipTop.endPoint)
        
        path.addCurve(to: curvePoints.tipRight)
        path.addCurve(to: curvePoints.bodyRight)
        path.addCurve(to: curvePoints.bodyBottom)
        path.addCurve(to: curvePoints.bodyLeft)
        path.addCurve(to: curvePoints.tipLeft)
        path.addCurve(to: curvePoints.tipTop)
        
        path.close()
        
        return path
    }
    
    static func square(_ value: CGFloat) -> CGFloat
    {
        return value * value
    }
    
    static func distance(p1: CGPoint, p2: CGPoint) -> CGFloat
    {
        let deltaX = p1.x - p2.x
        let deltaY = p1.y - p2.y
        return (square(deltaX) + square(deltaY)).squareRoot()
    }
    
    static func innerCircle(radius: CGFloat, controlOffset: CGFloat) -> (
        top: BezierPoint,
        right: BezierPoint,
        bottom: BezierPoint,
        left: BezierPoint)
    {
        let top = BezierPoint(endPoint: CGPoint(x: 0, y: -radius),
                              controlLeft: CGPoint(x: radius, y: -controlOffset),
                              controlRight: CGPoint(x: controlOffset, y: -radius))
        
        let right = BezierPoint(endPoint: CGPoint(x: -radius, y: 0),
                              controlLeft: CGPoint(x: -controlOffset, y: -radius),
                              controlRight: CGPoint(x: -radius, y: -controlOffset))
        
        let bottom = BezierPoint(endPoint: CGPoint(x: 0, y: radius),
                                 controlLeft: CGPoint(x: -radius, y: controlOffset),
                                 controlRight: CGPoint(x: -controlOffset, y: radius))
        
        let left = BezierPoint(endPoint: CGPoint(x: radius, y: 0),
                                controlLeft: CGPoint(x: controlOffset, y: radius),
                                controlRight: CGPoint(x: radius, y: controlOffset))
        
        return (top, right, bottom, left)
    }
    
    static func outerDial(bodyCenter: CGPoint, bodyRadius: CGFloat, tipCenter: CGPoint, tipRadius: CGFloat) -> (
        tipTop: BezierPoint,
        tipRight: BezierPoint,
        tipLeft: BezierPoint,
        bodyBottom: BezierPoint,
        bodyRight: BezierPoint,
        bodyLeft: BezierPoint)
    {
        let specialFactor: CGFloat = 0.85
        
        let distanceCenters = distance(p1: bodyCenter, p2: tipCenter)
        let differenceRadius = (bodyRadius - tipRadius)
        
        // We use the pythagorean theorem to find the third side of a right triangle
        // a^2 + b^2 = c^2
        // In this case, we have a^2 and c^2 but not b^2
        let distanceTangents = (square(distanceCenters) - square(differenceRadius)).squareRoot()
        
        // Now we use the law of sines to find the angle that the tangent is from the center of the circle
        let theta = asin(distanceTangents / distanceCenters)
        
        // We have to get the angle that is 90° - theta
        let thetaComplement = (CGFloat.pi / 2) - theta
        
        // We know that the cosine of theta = x / radius, and the sine of theta = y / radius
        // Also, upwards (on the screen) is negative
        let bodyRight = BezierPoint(endPoint: CGPoint(x: bodyCenter.x + bodyRadius * cos(thetaComplement),
                                                      y: bodyCenter.y - bodyRadius * sin(thetaComplement)),
                                    controlLeft: CGPoint(x: bodyCenter.x + bodyRadius * cos(thetaComplement),
                                                        y: bodyCenter.y - bodyRadius * sin(thetaComplement)) ,
                                    controlRight: CGPoint(x: bodyCenter.x + bodyRadius * cos(thetaComplement),
                                                          y: bodyCenter.y - bodyRadius * sin(thetaComplement)))
        
        let bodyLeft = BezierPoint(endPoint: CGPoint(x: bodyRight.endPoint.x * -1, y: bodyRight.endPoint.y),
                                   controlLeft: CGPoint(x: bodyRight.controlRight.x * -1, y: bodyRight.controlRight.y),
                                   controlRight: CGPoint(x: bodyRight.controlLeft.x * -1, y: bodyRight.controlLeft.y))
        
        // Now, we have to find the points on the top circle. It's similar to the bottom one, but we use a different radius
        
        let tipRight = BezierPoint(endPoint: CGPoint(x: tipCenter.x + (tipRadius * cos(thetaComplement)),
                                                     y: tipCenter.y + (tipRadius * sin(thetaComplement))),
                                   controlLeft: CGPoint(x: tipCenter.x + (tipRadius * cos(thetaComplement)),
                                                        y: tipCenter.y + (tipRadius * sin(thetaComplement))),
                                    controlRight: CGPoint(x: tipCenter.x + (tipRadius * cos(thetaComplement)),
                                                          y: tipCenter.y + (tipRadius * sin(thetaComplement))))
        
        let tipLeft = BezierPoint(endPoint: CGPoint(x: tipRight.endPoint.x * -1,
                                                    y: tipRight.endPoint.y),
                                  controlLeft: CGPoint(x: tipRight.controlRight.x * -1, y: tipRight.controlRight.y),
                                  controlRight: CGPoint(x: tipRight.controlLeft.x * -1, y: tipRight.controlLeft.y))
        
        // Now, for the easy control point origins. Negative y is upwards
        
        let tipTop = BezierPoint(endPoint: CGPoint(x: tipCenter.x,
                                                   y: tipCenter.y - tipRadius),
                                 controlLeft: CGPoint(x: tipCenter.x - tipRadius * specialFactor,
                                                      y: tipCenter.y - tipRadius),
                                 controlRight: CGPoint(x: tipCenter.x + tipRadius * specialFactor,
                                                       y: tipCenter.y - tipRadius))
        
        let bodyBottom = BezierPoint(endPoint: CGPoint(x: bodyCenter.x,
                                                       y: bodyCenter.y + bodyRadius),
                                     controlLeft: CGPoint(x: bodyCenter.x - bodyRadius * specialFactor,
                                                          y: bodyCenter.y + bodyRadius),
                                     controlRight: CGPoint(x: bodyCenter.x + bodyRadius * specialFactor,
                                                           y: bodyCenter.y + bodyRadius))
        
        return (tipTop, tipRight, tipLeft, bodyBottom, bodyRight, bodyLeft)
    }
    
    //// Generated Images
    
    static func imageOfTickTask(angle: CGFloat, size: CGSize, state: DialState) -> UIImage
    {
        let color: String
        
        switch state
        {
        case .countdown:
            color = "red"
        case .inactive:
            color = "green"
        case .selected:
            color = "yellow"
        }
        
        // We only want to save the images when the user is modifying the dial image,
        // because otherwise the app would take a huge amount of space...
        if state == .selected,
            let image = AngleImage.image(with: angle, color: color),
            let imageData = image.imageData,
            let final = UIImage(data: imageData)
        {
            return final
        }
        else
        {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            DialImage.drawTickTask(frame: CGRect(origin: CGPoint.zero, size: size),
                                   angle: angle,
                                   state: state)
            
            let imageOfTickTask = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            if state == .selected
            {
                let image = AngleImage(context: Model.context)
                image.angle = Double(angle)
                image.imageData = imageOfTickTask.pngData()
                image.color = color
                
                Model.save()
            }
            
            return imageOfTickTask
        }
    }
}
