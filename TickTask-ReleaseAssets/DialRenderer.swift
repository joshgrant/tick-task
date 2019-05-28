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
    override class func nameWith(duration: Int, dimension: Int) -> String
    {
        return "Dial_\(duration)_\(dimension)"
    }
    
    override class func imageWith(duration: Int, dimension: Int) -> NSImage
    {
        let size = CGSize(square: CGFloat(dimension))
        
        let image = NSImage(size: size, flipped: false) { (bounds) -> Bool in
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
            
            let angleRadians = TimeInterval(exactly: duration * 60)!.toAngle()
            
            DialShape(drawingData: drawingData).draw(context: context, angle: angleRadians, state: .inactive)
            
            return true
        }
        
        return image
    }
    
    override class func render()
    {
        let infos: [DialRenderer] = [
            DialRenderer(duration: 0, dimension: 320),
            DialRenderer(duration: 0, dimension: 320 * 2),
            DialRenderer(duration: 0, dimension: 320 * 3),
            DialRenderer(duration: 0, dimension: 375),
            DialRenderer(duration: 0, dimension: 375 * 2),
            DialRenderer(duration: 0, dimension: 375 * 3),
            DialRenderer(duration: 0, dimension: 414),
            DialRenderer(duration: 0, dimension: 414 * 2),
            DialRenderer(duration: 0, dimension: 414 * 3),
            DialRenderer(duration: 0, dimension: 768),
            DialRenderer(duration: 0, dimension: 768 * 2),
            DialRenderer(duration: 0, dimension: 768 * 3),
            DialRenderer(duration: 0, dimension: 1024),
            DialRenderer(duration: 0, dimension: 1024 * 2),
            DialRenderer(duration: 0, dimension: 1024 * 3),
            DialRenderer(duration: 0, dimension: 110),
            DialRenderer(duration: 0, dimension: 110 * 2),
            DialRenderer(duration: 0, dimension: 110 * 3),
            DialRenderer(duration: 25, dimension: 110),
            DialRenderer(duration: 25, dimension: 110 * 2),
            DialRenderer(duration: 25, dimension: 110 * 3),
            DialRenderer(duration: 35, dimension: 110),
            DialRenderer(duration: 35, dimension: 110 * 2),
            DialRenderer(duration: 35, dimension: 110 * 3),
        ]
        
        for info in infos
        {
            info.createFile()
        }
    }
}
