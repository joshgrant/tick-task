//
//  CGContext+.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreGraphics

extension CGContext
{
    func setShadow(shadow: Shadow)
    {
        #if os(iOS)
        self.setShadow(offset: shadow.offset,
                       blur: shadow.blur,
                       color: shadow.color.cgColor)
        #elseif os(OSX)
        self.setShadow(offset: shadow.offset.applying(CGAffineTransform(scaleX: 1, y: -1)),
                       blur: shadow.blur,
                       color: shadow.color.cgColor)
        #endif
    }
    
    func pushPop(closure: () -> ())
    {
        self.saveGState()
        
        closure()
        
        self.restoreGState()
    }
    
    func pushPopTransparency(in rect: CGRect? = nil, closure: () -> ())
    {
        if let rect = rect
        {
            self.beginTransparencyLayer(in: rect, auxiliaryInfo: nil)
        }
        else
        {
            self.beginTransparencyLayer(auxiliaryInfo: nil)
        }
        
        closure()
        
        self.endTransparencyLayer()
    }
}
