//
//  Color.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/25/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

typealias ColorModification = (CGFloat) -> CGFloat

typealias Modification = (CGFloat, CGFloat, CGFloat, CGFloat) -> (CGFloat, CGFloat, CGFloat, CGFloat)

struct Color
{
    var hue: CGFloat
    var saturation: CGFloat
    var brightness: CGFloat
    var alpha: CGFloat
    
    var uiColor: UIColor {
        return UIColor(hue: hue,
                       saturation: saturation,
                       brightness: brightness,
                       alpha: alpha)
    }
    
    var cgColor: CGColor {
        return uiColor.cgColor
    }
    
//    func colorByApplying(modification: Modification)
//    {
//
//
//        return Color(hue: mod, saturation: <#T##CGFloat#>, brightness: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
//    }
    
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
}
