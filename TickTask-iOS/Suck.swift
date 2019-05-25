////
////  Suck.swift
////  TickTask-iOS
////
////  Created by Joshua Grant on 5/25/19.
////  Copyright © 2019 joshgrant. All rights reserved.
////
//
//import UIKit
//
//class Dial: NSObject
//{
//    
//    
//    //MARK: - Canvas Drawings
//    
//    /// Page 1
//    
//    class func drawIcon(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 512, height: 512), resizing: ResizingBehavior = .aspectFit)
//    {
//        /// General Declarations
//        let context = UIGraphicsGetCurrentContext()!
//        let baseTransform = context.userSpaceToDeviceSpaceTransform.inverted()
//        
//        /// Resize to Target Frame
//        context.saveGState()
//        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
//        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
//        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)
//        
//        /// Background Color
//        UIColor.white.setFill()
//        context.fill(context.boundingBoxOfClipPath)
//        
//        /// tickTask-oval5
//        let tickTaskoval5 = UIBezierPath()
//        tickTaskoval5.move(to: CGPoint(x: 222, y: 444))
//        tickTaskoval5.addCurve(to: CGPoint(x: 444, y: 222), controlPoint1: CGPoint(x: 344.61, y: 444), controlPoint2: CGPoint(x: 444, y: 344.61))
//        tickTaskoval5.addCurve(to: CGPoint(x: 222, y: 0), controlPoint1: CGPoint(x: 444, y: 99.39), controlPoint2: CGPoint(x: 344.61, y: 0))
//        tickTaskoval5.addCurve(to: CGPoint(x: 0, y: 222), controlPoint1: CGPoint(x: 99.39, y: 0), controlPoint2: CGPoint(x: 0, y: 99.39))
//        tickTaskoval5.addCurve(to: CGPoint(x: 222, y: 444), controlPoint1: CGPoint(x: 0, y: 344.61), controlPoint2: CGPoint(x: 99.39, y: 444))
//        tickTaskoval5.close()
//        context.saveGState()
//        context.translateBy(x: 34, y: 34)
//        context.saveGState()
//        context.beginPath()
//        context.addPath(tickTaskoval5.cgPath)
//        context.addRect(tickTaskoval5.bounds.insetBy(dx: -20, dy: -28))
//        context.clip(using: .evenOdd)
//        context.translateBy(x: -465, y: 0)
//        do
//        {
//            let baseZero = context.convertToDeviceSpace(CGPoint.zero).applying(baseTransform)
//            let baseOne = context.convertToDeviceSpace(CGPoint(x: 1, y: 1)).applying(baseTransform)
//            let baseOffset = context.convertToDeviceSpace(CGPoint(x: 465, y: 8)).applying(baseTransform)
//            let shadowOffset = CGSize(width: baseOffset.x - baseZero.x, height: baseOffset.y - baseZero.y)
//            let shadowBlur: CGFloat = 20 * min(baseOne.x - baseZero.x, baseOne.y - baseZero.y)
//            context.setShadow(offset: shadowOffset, blur: shadowBlur, color: UIColor(white: 0, alpha: 0.8).cgColor)
//        }
//        UIColor.black.setFill()
//        tickTaskoval5.fill()
//        context.restoreGState()
//        UIColor.black.setFill()
//        tickTaskoval5.fill()
//        context.restoreGState()
//        
//        /// Oval
//        let oval = UIBezierPath()
//        oval.move(to: CGPoint(x: 222, y: 444))
//        oval.addCurve(to: CGPoint(x: 444, y: 222), controlPoint1: CGPoint(x: 344.61, y: 444), controlPoint2: CGPoint(x: 444, y: 344.61))
//        oval.addCurve(to: CGPoint(x: 222, y: 0), controlPoint1: CGPoint(x: 444, y: 99.39), controlPoint2: CGPoint(x: 344.61, y: 0))
//        oval.addCurve(to: CGPoint(x: 0, y: 222), controlPoint1: CGPoint(x: 99.39, y: 0), controlPoint2: CGPoint(x: 0, y: 99.39))
//        oval.addCurve(to: CGPoint(x: 222, y: 444), controlPoint1: CGPoint(x: 0, y: 344.61), controlPoint2: CGPoint(x: 99.39, y: 444))
//        oval.close()
//        context.saveGState()
//        context.translateBy(x: 34, y: 34)
//        oval.lineWidth = 1
//        UIColor(white: 1, alpha: 0.2).setStroke()
//        oval.stroke()
//        context.restoreGState()
//        
//        /// tickTask-oval
//        let tickTaskoval = UIBezierPath()
//        tickTaskoval.move(to: CGPoint(x: 222, y: 444))
//        tickTaskoval.addCurve(to: CGPoint(x: 444, y: 222), controlPoint1: CGPoint(x: 344.61, y: 444), controlPoint2: CGPoint(x: 444, y: 344.61))
//        tickTaskoval.addCurve(to: CGPoint(x: 222, y: 0), controlPoint1: CGPoint(x: 444, y: 99.39), controlPoint2: CGPoint(x: 344.61, y: 0))
//        tickTaskoval.addCurve(to: CGPoint(x: 0, y: 222), controlPoint1: CGPoint(x: 99.39, y: 0), controlPoint2: CGPoint(x: 0, y: 99.39))
//        tickTaskoval.addCurve(to: CGPoint(x: 222, y: 444), controlPoint1: CGPoint(x: 0, y: 344.61), controlPoint2: CGPoint(x: 99.39, y: 444))
//        tickTaskoval.close()
//        context.saveGState()
//        context.translateBy(x: 34, y: 34)
//        context.saveGState()
//        tickTaskoval.addClip()
//        context.drawLinearGradient(CGGradient(colorsSpace: nil, colors: [
//            UIColor(hue: 0.333, saturation: 0.023, brightness: 0.341, alpha: 0.64).cgColor,
//            UIColor(hue: 0.333, saturation: 0.052, brightness: 0.227, alpha: 0.56).cgColor,
//            ] as CFArray, locations: [0, 1])!,
//                                   start: CGPoint(x: 222, y: 0),
//                                   end: CGPoint(x: 222, y: 444),
//                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
//        context.restoreGState()
//        context.restoreGState()
//        
//        /// tickTask-oval4
//        let tickTaskoval4 = UIBezierPath()
//        tickTaskoval4.move(to: CGPoint(x: 213, y: 426))
//        tickTaskoval4.addCurve(to: CGPoint(x: 426, y: 213), controlPoint1: CGPoint(x: 330.64, y: 426), controlPoint2: CGPoint(x: 426, y: 330.64))
//        tickTaskoval4.addCurve(to: CGPoint(x: 213, y: 0), controlPoint1: CGPoint(x: 426, y: 95.36), controlPoint2: CGPoint(x: 330.64, y: 0))
//        tickTaskoval4.addCurve(to: CGPoint(x: 0, y: 213), controlPoint1: CGPoint(x: 95.36, y: 0), controlPoint2: CGPoint(x: 0, y: 95.36))
//        tickTaskoval4.addCurve(to: CGPoint(x: 213, y: 426), controlPoint1: CGPoint(x: 0, y: 330.64), controlPoint2: CGPoint(x: 95.36, y: 426))
//        tickTaskoval4.close()
//        context.saveGState()
//        context.translateBy(x: 43, y: 43)
//        UIColor(hue: 0.333, saturation: 0.029, brightness: 0.19, alpha: 1).setFill()
//        tickTaskoval4.fill()
//        context.restoreGState()
//        
//        /// tickTask-oval2
//        let tickTaskoval2 = UIBezierPath()
//        tickTaskoval2.move(to: CGPoint(x: 204, y: 408))
//        tickTaskoval2.addCurve(to: CGPoint(x: 408, y: 204), controlPoint1: CGPoint(x: 316.67, y: 408), controlPoint2: CGPoint(x: 408, y: 316.67))
//        tickTaskoval2.addCurve(to: CGPoint(x: 204, y: 0), controlPoint1: CGPoint(x: 408, y: 91.33), controlPoint2: CGPoint(x: 316.67, y: 0))
//        tickTaskoval2.addCurve(to: CGPoint(x: 0, y: 204), controlPoint1: CGPoint(x: 91.33, y: 0), controlPoint2: CGPoint(x: 0, y: 91.33))
//        tickTaskoval2.addCurve(to: CGPoint(x: 204, y: 408), controlPoint1: CGPoint(x: 0, y: 316.67), controlPoint2: CGPoint(x: 91.33, y: 408))
//        tickTaskoval2.close()
//        context.saveGState()
//        context.translateBy(x: 52, y: 52)
//        context.saveGState()
//        tickTaskoval2.addClip()
//        context.drawLinearGradient(CGGradient(colorsSpace: nil, colors: [
//            UIColor(hue: 0.333, saturation: 0.04, brightness: 0.098, alpha: 0.71).cgColor,
//            UIColor(hue: 0.333, saturation: 0.023, brightness: 0.341, alpha: 0.28).cgColor,
//            ] as CFArray, locations: [0, 1])!,
//                                   start: CGPoint(x: 204, y: 0),
//                                   end: CGPoint(x: 204, y: 408),
//                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
//        context.restoreGState()
//        context.restoreGState()
//        
//        /// tickTask-oval3
//        let tickTaskoval3 = UIBezierPath()
//        tickTaskoval3.move(to: CGPoint(x: 195, y: 390))
//        tickTaskoval3.addCurve(to: CGPoint(x: 390, y: 195), controlPoint1: CGPoint(x: 302.7, y: 390), controlPoint2: CGPoint(x: 390, y: 302.7))
//        tickTaskoval3.addCurve(to: CGPoint(x: 195, y: 0), controlPoint1: CGPoint(x: 390, y: 87.3), controlPoint2: CGPoint(x: 302.7, y: 0))
//        tickTaskoval3.addCurve(to: CGPoint(x: 0, y: 195), controlPoint1: CGPoint(x: 87.3, y: 0), controlPoint2: CGPoint(x: 0, y: 87.3))
//        tickTaskoval3.addCurve(to: CGPoint(x: 195, y: 390), controlPoint1: CGPoint(x: 0, y: 302.7), controlPoint2: CGPoint(x: 87.3, y: 390))
//        tickTaskoval3.close()
//        context.saveGState()
//        context.translateBy(x: 61, y: 61)
//        UIColor(hue: 0.333, saturation: 0.045, brightness: 0.173, alpha: 0.64).setFill()
//        tickTaskoval3.fill()
//        context.restoreGState()
//        
//        /// Oval
//        let oval2 = UIBezierPath()
//        oval2.move(to: CGPoint(x: 175, y: 350))
//        oval2.addCurve(to: CGPoint(x: 350, y: 175), controlPoint1: CGPoint(x: 271.65, y: 350), controlPoint2: CGPoint(x: 350, y: 271.65))
//        oval2.addCurve(to: CGPoint(x: 175, y: 0), controlPoint1: CGPoint(x: 350, y: 78.35), controlPoint2: CGPoint(x: 271.65, y: 0))
//        oval2.addCurve(to: CGPoint(x: 0, y: 175), controlPoint1: CGPoint(x: 78.35, y: 0), controlPoint2: CGPoint(x: 0, y: 78.35))
//        oval2.addCurve(to: CGPoint(x: 175, y: 350), controlPoint1: CGPoint(x: 0, y: 271.65), controlPoint2: CGPoint(x: 78.35, y: 350))
//        oval2.close()
//        context.saveGState()
//        context.setBlendMode(.overlay)
//        context.beginTransparencyLayer(auxiliaryInfo: nil)
//        do
//        {
//            context.translateBy(x: 81, y: 81)
//            // Warning: Blur effects are not supported.
//            oval2.usesEvenOddFillRule = true
//            context.saveGState()
//            oval2.addClip()
//            // Warning: Angular gradients are not supported.
//            context.restoreGState()
//        }
//        context.endTransparencyLayer()
//        context.restoreGState()
//        
//        /// Oval
//        let oval3 = UIBezierPath()
//        oval3.move(to: CGPoint(x: 29, y: 58))
//        oval3.addCurve(to: CGPoint(x: 58, y: 29), controlPoint1: CGPoint(x: 45.02, y: 58), controlPoint2: CGPoint(x: 58, y: 45.02))
//        oval3.addCurve(to: CGPoint(x: 29, y: 0), controlPoint1: CGPoint(x: 58, y: 12.98), controlPoint2: CGPoint(x: 45.02, y: 0))
//        oval3.addCurve(to: CGPoint(x: 0, y: 29), controlPoint1: CGPoint(x: 12.98, y: 0), controlPoint2: CGPoint(x: 0, y: 12.98))
//        oval3.addCurve(to: CGPoint(x: 29, y: 58), controlPoint1: CGPoint(x: 0, y: 45.02), controlPoint2: CGPoint(x: 12.98, y: 58))
//        oval3.close()
//        context.saveGState()
//        context.translateBy(x: 227, y: 227)
//        oval3.usesEvenOddFillRule = true
//        UIColor(hue: 0.333, saturation: 0.042, brightness: 0.188, alpha: 1).setFill()
//        oval3.fill()
//        context.restoreGState()
//        
//        /// tickTask-bezier2
//        let tickTaskbezier2 = UIBezierPath()
//        tickTaskbezier2.move(to: CGPoint(x: 42, y: 157))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 23, y: 175.5), controlPoint1: CGPoint(x: 31.51, y: 157), controlPoint2: CGPoint(x: 23, y: 165.25))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 42, y: 194), controlPoint1: CGPoint(x: 23, y: 185.7), controlPoint2: CGPoint(x: 31.51, y: 194))
//        tickTaskbezier2.addLine(to: CGPoint(x: 42.27, y: 194))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 61, y: 175.5), controlPoint1: CGPoint(x: 52.63, y: 193.87), controlPoint2: CGPoint(x: 61, y: 185.62))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 42, y: 157), controlPoint1: CGPoint(x: 61, y: 165.25), controlPoint2: CGPoint(x: 52.49, y: 157))
//        tickTaskbezier2.close()
//        tickTaskbezier2.move(to: CGPoint(x: 54.69, y: 10.63))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 83.25, y: 167.31), controlPoint1: CGPoint(x: 56.24, y: 16.92), controlPoint2: CGPoint(x: 83.25, y: 167.31))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 42, y: 217), controlPoint1: CGPoint(x: 88.29, y: 195.26), controlPoint2: CGPoint(x: 67.2, y: 217))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 0.75, y: 167.31), controlPoint1: CGPoint(x: 16.84, y: 217), controlPoint2: CGPoint(x: -4.29, y: 195.26))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 29.31, y: 10.63), controlPoint1: CGPoint(x: 0.75, y: 167.31), controlPoint2: CGPoint(x: 28.47, y: 14.04))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 42, y: 0), controlPoint1: CGPoint(x: 30.86, y: 4.34), controlPoint2: CGPoint(x: 35.5, y: 0))
//        tickTaskbezier2.addCurve(to: CGPoint(x: 54.69, y: 10.63), controlPoint1: CGPoint(x: 48.5, y: 0), controlPoint2: CGPoint(x: 53.14, y: 4.34))
//        tickTaskbezier2.close()
//        context.saveGState()
//        context.translateBy(x: 214, y: 81)
//        context.saveGState()
//        context.beginPath()
//        context.addPath(tickTaskbezier2.cgPath)
//        context.addRect(tickTaskbezier2.bounds.insetBy(dx: -8, dy: -14))
//        context.clip(using: .evenOdd)
//        context.translateBy(x: -93, y: 0)
//        do
//        {
//            let baseZero = context.convertToDeviceSpace(CGPoint.zero).applying(baseTransform)
//            let baseOne = context.convertToDeviceSpace(CGPoint(x: 1, y: 1)).applying(baseTransform)
//            let baseOffset = context.convertToDeviceSpace(CGPoint(x: 93, y: 6)).applying(baseTransform)
//            let shadowOffset = CGSize(width: baseOffset.x - baseZero.x, height: baseOffset.y - baseZero.y)
//            let shadowBlur: CGFloat = 8 * min(baseOne.x - baseZero.x, baseOne.y - baseZero.y)
//            context.setShadow(offset: shadowOffset, blur: shadowBlur, color: UIColor(white: 0, alpha: 0.2).cgColor)
//        }
//        UIColor.black.setFill()
//        tickTaskbezier2.fill()
//        context.restoreGState()
//        context.saveGState()
//        context.beginPath()
//        context.addPath(tickTaskbezier2.cgPath)
//        context.addRect(tickTaskbezier2.bounds.insetBy(dx: -40, dy: -40))
//        context.clip(using: .evenOdd)
//        context.translateBy(x: -165, y: 0)
//        do
//        {
//            let baseZero = context.convertToDeviceSpace(CGPoint.zero).applying(baseTransform)
//            let baseOne = context.convertToDeviceSpace(CGPoint(x: 1, y: 1)).applying(baseTransform)
//            let baseOffset = context.convertToDeviceSpace(CGPoint(x: 165, y: 0)).applying(baseTransform)
//            let shadowOffset = CGSize(width: baseOffset.x - baseZero.x, height: baseOffset.y - baseZero.y)
//            let shadowBlur: CGFloat = 0 * min(baseOne.x - baseZero.x, baseOne.y - baseZero.y)
//            context.setShadow(offset: shadowOffset, blur: shadowBlur, color: UIColor(white: 0, alpha: 0.25).cgColor)
//        }
//        context.beginTransparencyLayer(auxiliaryInfo: nil)
//        do
//        {
//            UIColor.black.setFill()
//            tickTaskbezier2.fill()
//            context.saveGState()
//            tickTaskbezier2.lineWidth = 8
//            UIColor.black.setStroke()
//            tickTaskbezier2.stroke()
//            context.restoreGState()
//        }
//        context.endTransparencyLayer()
//        context.restoreGState()
//        context.saveGState()
//        context.beginPath()
//        context.addPath(tickTaskbezier2.cgPath)
//        context.addRect(tickTaskbezier2.bounds.insetBy(dx: -30, dy: -20))
//        context.clip(using: .evenOdd)
//        context.translateBy(x: -115, y: 0)
//        do
//        {
//            let baseZero = context.convertToDeviceSpace(CGPoint.zero).applying(baseTransform)
//            let baseOne = context.convertToDeviceSpace(CGPoint(x: 1, y: 1)).applying(baseTransform)
//            let baseOffset = context.convertToDeviceSpace(CGPoint(x: 125, y: 0)).applying(baseTransform)
//            let shadowOffset = CGSize(width: baseOffset.x - baseZero.x, height: baseOffset.y - baseZero.y)
//            let shadowBlur: CGFloat = 20 * min(baseOne.x - baseZero.x, baseOne.y - baseZero.y)
//            context.setShadow(offset: shadowOffset, blur: shadowBlur, color: UIColor(white: 0, alpha: 0.5).cgColor)
//        }
//        UIColor.black.setFill()
//        tickTaskbezier2.fill()
//        context.restoreGState()
//        UIColor(hue: 0.42, saturation: 0.722, brightness: 0.902, alpha: 1).setFill()
//        tickTaskbezier2.fill()
//        context.saveGState()
//        UIRectClip(tickTaskbezier2.bounds)
//        context.setShadow(offset: CGSize.zero, blur: 0, color: nil)
//        context.setAlpha(0.5)
//        context.beginTransparencyLayer(in: tickTaskbezier2.bounds, auxiliaryInfo: nil)
//        do
//        {
//            UIColor.white.setFill()
//            tickTaskbezier2.fill()
//            context.setBlendMode(.destinationOut)
//            context.beginTransparencyLayer(in: tickTaskbezier2.bounds, auxiliaryInfo: nil)
//            do
//            {
//                context.translateBy(x: -84, y: 0)
//                do
//                {
//                    let baseZero = context.convertToDeviceSpace(CGPoint.zero).applying(baseTransform)
//                    let baseOne = context.convertToDeviceSpace(CGPoint(x: 1, y: 1)).applying(baseTransform)
//                    let baseOffset = context.convertToDeviceSpace(CGPoint(x: 84, y: 4)).applying(baseTransform)
//                    let shadowOffset = CGSize(width: baseOffset.x - baseZero.x, height: baseOffset.y - baseZero.y)
//                    let shadowBlur: CGFloat = 1 * min(baseOne.x - baseZero.x, baseOne.y - baseZero.y)
//                    context.setShadow(offset: shadowOffset, blur: shadowBlur, color: UIColor.black.cgColor)
//                }
//                UIColor.black.setFill()
//                tickTaskbezier2.fill()
//            }
//            context.endTransparencyLayer()
//        }
//        context.endTransparencyLayer()
//        context.restoreGState()
//        context.saveGState()
//        UIRectClip(tickTaskbezier2.bounds)
//        context.setShadow(offset: CGSize.zero, blur: 0, color: nil)
//        context.setAlpha(0.5)
//        context.beginTransparencyLayer(in: tickTaskbezier2.bounds, auxiliaryInfo: nil)
//        do
//        {
//            UIColor.black.setFill()
//            tickTaskbezier2.fill()
//            context.setBlendMode(.destinationOut)
//            context.beginTransparencyLayer(in: tickTaskbezier2.bounds, auxiliaryInfo: nil)
//            do
//            {
//                context.translateBy(x: -84, y: 0)
//                do
//                {
//                    let baseZero = context.convertToDeviceSpace(CGPoint.zero).applying(baseTransform)
//                    let baseOne = context.convertToDeviceSpace(CGPoint(x: 1, y: 1)).applying(baseTransform)
//                    let baseOffset = context.convertToDeviceSpace(CGPoint(x: 84, y: -4)).applying(baseTransform)
//                    let shadowOffset = CGSize(width: baseOffset.x - baseZero.x, height: baseOffset.y - baseZero.y)
//                    let shadowBlur: CGFloat = 1 * min(baseOne.x - baseZero.x, baseOne.y - baseZero.y)
//                    context.setShadow(offset: shadowOffset, blur: shadowBlur, color: UIColor.black.cgColor)
//                }
//                UIColor.black.setFill()
//                tickTaskbezier2.fill()
//            }
//            context.endTransparencyLayer()
//        }
//        context.endTransparencyLayer()
//        context.restoreGState()
//        context.restoreGState()
//        
//        /// Smooth Corners
//        // Warning: New symbols are not supported.
//        
//        context.restoreGState()
//    }
//    
//    
//    //MARK: - Canvas Images
//    
//    /// Page 1
//    
//    class func imageOfIcon() -> UIImage
//    {
//        struct LocalCache
//        {
//            static var image: UIImage!
//        }
//        if LocalCache.image != nil
//        {
//            return LocalCache.image
//        }
//        var image: UIImage
//        
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
//        Dial.drawIcon()
//        image = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        LocalCache.image = image
//        return image
//    }
//    
//    
//    //MARK: - Resizing Behavior
//    
//    enum ResizingBehavior
//    {
//        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
//        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
//        case stretch /// The content is stretched to match the entire target rectangle.
//        case center /// The content is centered in the target rectangle, but it is NOT resized.
//        
//        func apply(rect: CGRect, target: CGRect) -> CGRect
//        {
//            if rect == target || target == CGRect.zero
//            {
//                return rect
//            }
//            
//            var scales = CGSize.zero
//            scales.width = abs(target.width / rect.width)
//            scales.height = abs(target.height / rect.height)
//            
//            switch self
//            {
//            case .aspectFit:
//                scales.width = min(scales.width, scales.height)
//                scales.height = scales.width
//            case .aspectFill:
//                scales.width = max(scales.width, scales.height)
//                scales.height = scales.width
//            case .stretch:
//                break
//            case .center:
//                scales.width = 1
//                scales.height = 1
//            }
//            
//            var result = rect.standardized
//            result.size.width *= scales.width
//            result.size.height *= scales.height
//            result.origin.x = target.minX + (target.width - result.width) / 2
//            result.origin.y = target.minY + (target.height - result.height) / 2
//            return result
//        }
//    }
//    
//    
//}
