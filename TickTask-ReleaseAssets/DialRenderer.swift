//
//  DialRenderer.swift
//  TickTask-ReleaseAssets
//
//  Created by Joshua Grant on 5/28/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

class DialRenderer: Renderer
{
    override var prefix: String {
        return "Dial"
    }
    
    override var image: NSImage {
        
        let state: DialState
        
        switch duration
        {
        case 0:
            state = .inactive
        case 25:
            state = .selected
        default:
            state = .countdown
        }
        
        let image = NSImage(size: size, flipped: true) { (bounds) -> Bool in
            let drawingData = DrawingData(rect: bounds)
            
            guard let context = NSGraphicsContext.current?.cgContext else {
                debugPrint("No context")
                return false
            }
            
            Circle.faceBackgroundCircle(with: drawingData).draw(context: context)
            Circle.outerRimCircle(with: drawingData).draw(context: context)
            Circle.centerRimCircle(with: drawingData).draw(context: context)
            Circle.innerRimCircle(with: drawingData).draw(context: context)
            Circle.faceInnerCircle(with: drawingData).draw(context: context)
            
            DialShape(drawingData: drawingData).draw(context: context, angle: self.angle, state: state)
            
            return true
        }
        
        return image
    }
    
    override class func render()
    {
        let infos: [DialRenderer] = [
            DialRenderer(duration: 0, dimension: 320),
            DialRenderer(duration: 0, dimension: 320, scale: 2),
            DialRenderer(duration: 0, dimension: 320, scale: 3),
            DialRenderer(duration: 0, dimension: 375),
            DialRenderer(duration: 0, dimension: 375, scale: 2),
            DialRenderer(duration: 0, dimension: 375, scale: 3),
            DialRenderer(duration: 0, dimension: 414),
            DialRenderer(duration: 0, dimension: 414, scale: 2),
            DialRenderer(duration: 0, dimension: 414, scale: 3),
            DialRenderer(duration: 0, dimension: 768),
            DialRenderer(duration: 0, dimension: 768, scale: 2),
            DialRenderer(duration: 0, dimension: 768, scale: 3),
            DialRenderer(duration: 0, dimension: 1024),
            DialRenderer(duration: 0, dimension: 1024, scale: 2),
            DialRenderer(duration: 0, dimension: 1024, scale: 3),
            DialRenderer(duration: 0, dimension: 110),
            DialRenderer(duration: 0, dimension: 110, scale: 2),
            DialRenderer(duration: 0, dimension: 110, scale: 3),
            DialRenderer(duration: 25, dimension: 110),
            DialRenderer(duration: 25, dimension: 110, scale: 2),
            DialRenderer(duration: 25, dimension: 110, scale: 3),
            DialRenderer(duration: 12.4, dimension: 110),
            DialRenderer(duration: 12.4, dimension: 110, scale: 2),
            DialRenderer(duration: 12.4, dimension: 110, scale: 3),
        ]
        
        for info in infos
        {
            info.createFile()
        }
    }
}
