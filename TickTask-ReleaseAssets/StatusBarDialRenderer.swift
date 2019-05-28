//
//  StatusBarDialRenderer.swift
//  TickTask-ReleaseAssets
//
//  Created by Joshua Grant on 5/28/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

class StatusBarDialRenderer: Renderer
{
    override class func nameWith(duration: Int, dimension: Int) -> String
    {
        return "StatusBarDial_\(duration)_\(dimension)"
    }
    
    override class func imageWith(duration: Int, dimension: Int) -> NSImage
    {
        let angleRadians = TimeInterval(exactly: duration * 60)!.toAngle()
        return NSImage.statusItemDialWithRotation(angle: angleRadians,
                                                  size: CGSize(square: CGFloat(dimension)))
    }
    
    override class func render()
    {
        let infos: [StatusBarDialRenderer] = [
            StatusBarDialRenderer(duration: 0, dimension: 22),
            StatusBarDialRenderer(duration: 0, dimension: 22 * 2),
            StatusBarDialRenderer(duration: 0, dimension: 22 * 3),
            StatusBarDialRenderer(duration: 25, dimension: 22),
            StatusBarDialRenderer(duration: 25, dimension: 22 * 2),
            StatusBarDialRenderer(duration: 25, dimension: 22 * 3),
            StatusBarDialRenderer(duration: 35, dimension: 22),
            StatusBarDialRenderer(duration: 35, dimension: 22 * 2),
            StatusBarDialRenderer(duration: 35, dimension: 22 * 3),
        ]
        
        for info in infos
        {
            info.createFile()
        }
    }
}
