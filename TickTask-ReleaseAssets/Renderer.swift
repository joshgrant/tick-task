//
//  Renderer.swift
//  TickTask-ReleaseAssets
//
//  Created by Joshua Grant on 5/28/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

class Renderer
{
    var duration: CGFloat
    var dimension: Int
    var scale: Int
    
    var size: CGSize {
        return CGSize(square: CGFloat(dimension * scale))
    }
    
    var angle: CGFloat {
        return TimeInterval(exactly: duration * 60)!.toAngle()
    }
    
    var prefix: String {
        return ""
    }
    
    var name: String {
        let postfix = "@\(scale)x"
        return "\(prefix)_\(Int(duration))_\(dimension)\(scale == 1 ? "" : postfix)"
    }
    
    var image: NSImage {
        return NSImage()
    }
    
    static var path: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
    
    class func render() {}
    
    // MARK: Initialization
    
    init(duration: CGFloat, dimension: Int, scale: Int = 1)
    {
        self.duration = duration
        self.dimension = dimension
        self.scale = scale
    }
    
    func createFile(basePath: String = Renderer.path)
    {
        guard let data = image.tiffRepresentation else { return }
        guard let bitmap = NSBitmapImageRep(data: data) else { return }
        guard let png = bitmap.representation(using: .png, properties: [:]) else { return }
        
        FileManager.default.createFile(
            atPath: "\(basePath)/\(name).png",
            contents: png,
            attributes: nil)
    }
}
