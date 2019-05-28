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
    override var prefix: String {
        return "StatusBarDial"
    }
    
    override var image: NSImage {
        return NSImage.statusItemDialWithRotation(angle: angle, size: size)
    }
    
    override class func render()
    {
        let infos: [StatusBarDialRenderer] = [
            StatusBarDialRenderer(duration: 0, dimension: 22),
            StatusBarDialRenderer(duration: 0, dimension: 22, scale: 2),
            StatusBarDialRenderer(duration: 0, dimension: 22, scale: 3),
            StatusBarDialRenderer(duration: 25, dimension: 22),
            StatusBarDialRenderer(duration: 25, dimension: 22, scale: 2),
            StatusBarDialRenderer(duration: 25, dimension: 22, scale: 3),
            StatusBarDialRenderer(duration: 12.4, dimension: 22),
            StatusBarDialRenderer(duration: 12.4, dimension: 22, scale: 2),
            StatusBarDialRenderer(duration: 12.4, dimension: 22, scale: 3),
        ]
        
        for info in infos
        {
            info.createFile()
        }
    }
}
