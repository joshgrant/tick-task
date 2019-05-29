//
//  Color.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/25/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

typealias ColorModification = (CGFloat) -> CGFloat

struct Color
{
    // MARK: Color Types
    
    static var faceFill: Color { return Color(brightness: 0.11) }
    static var faceDropShadow: Color { return Color(brightness: 0.0, alpha: 0.8) }
    
    static var dialFillInactive: Color { return Color(hue: 0.39, saturation: 0.9, brightness: 1.0) }
    static var dialFillSelected: Color { return Color(hue: 0.18, saturation: 0.66, brightness: 1.0)
    }
    static var dialFillCountdown: Color { return Color(hue: 0.0, saturation: 0.65, brightness: 1.0) }
    
    static var dialOuterDropShadow: Color { return Color(alpha: 0.6) }
    static var dialOuterStrokeShadow: Color { return Color(alpha: 0.2) }
    static var dialInnerHighlight: Color { return Color(brightness: 1.0, alpha: 0.3) }
    static var dialInnerShadow: Color { return Color(alpha: 0.3) }
    
    static var outerRimGradientHighlight: Color { return faceFill.mix(brightness: 1.0, alpha: 0.3) }
    static var outerRimGradientShadow: Color { return faceFill.mix(alpha: 0.4) }
    
    static var innerRimGradientHighlight: Color { return faceFill.mix(brightness: 1.0, alpha: 0.3) }
    static var innerRimGradientShadow: Color { return faceFill.mix(alpha: 0.4) }
    
    // MARK: Properties
    
    var hue: CGFloat
    var saturation: CGFloat
    var brightness: CGFloat
    var alpha: CGFloat
    
    // MARK: Initialization
    
    init(hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 1)
    {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    
    #if os(iOS)
    var color: UIColor {
        return UIColor(hue: hue,
                       saturation: saturation,
                       brightness: brightness,
                       alpha: alpha)
    }
    
    init(color: UIColor)
    {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    
    #elseif os(OSX)
    var color: NSColor {
        return NSColor(hue: hue,
                       saturation: saturation,
                       brightness: brightness,
                       alpha: alpha)
    }
    #endif
    
    var cgColor: CGColor {
        return color.cgColor
    }
    
    func mix(with color: Color) -> Color
    {
        return Color(hue: color.hue * 0.5 + self.hue * 0.5,
                     saturation: color.saturation * 0.5 + self.saturation * 0.5,
                     brightness: color.brightness * 0.5 + self.brightness * 0.5,
                     alpha: color.alpha * 0.5 + self.alpha * 0.5)
    }
    
    func mix(brightness: CGFloat = 0, alpha: CGFloat = 1) -> Color
    {
        return Color(hue: hue,
                     saturation: saturation,
                     brightness: brightness * alpha + (1.0 - alpha) * self.brightness,
                     alpha: alpha)
    }
    
    func colorBySetting(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, alpha: CGFloat? = nil) -> Color
    {
        return Color(hue: hue ?? self.hue,
                     saturation: saturation ?? self.saturation,
                     brightness: brightness ?? self.brightness,
                     alpha: alpha ?? self.alpha)
    }
    
    func colorByApplying(hueModification: ColorModification? = nil,
                         saturationModification: ColorModification? = nil,
                         brightnessModification: ColorModification? = nil,
                         alphaModification: ColorModification? = nil) -> Color
    {
        return Color(hue: hueModification?(hue) ?? hue,
                     saturation: saturationModification?(saturation) ?? saturation,
                     brightness: brightnessModification?(brightness) ?? brightness,
                     alpha: alphaModification?(alpha) ?? alpha)
    }
    
    func colorByApplying(brightnessAndAlphaModification: @escaping ColorModification) -> Color
    {
        return colorByApplying(brightnessModification: brightnessAndAlphaModification,
                               alphaModification: brightnessAndAlphaModification)
    }
    
    func colorByApplying(allModification: @escaping ColorModification) -> Color
    {
        return colorByApplying(hueModification: allModification,
                               saturationModification: allModification,
                               brightnessModification: allModification,
                               alphaModification: allModification)
    }
    
    // MARK: Drawing
    
    func draw(with context: CGContext, in path: Path)
    {
        context.pushPop {
            self.setFill()
            path.fill()
        }
    }
    
    func setFill()
    {
        color.setFill()
    }
    
    func setStroke()
    {
        color.setStroke()
    }
}
