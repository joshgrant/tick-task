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
    var name: String
    var image: NSImage
    
    static var path: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
    
    class func nameWith(duration: Int, dimension: Int) -> String
    {
        return ""
    }
    
    class func imageWith(duration: Int, dimension: Int) -> NSImage
    {
        return NSImage()
    }
    
    class func render() {}
    
    // MARK: Initialization
    
    init(duration: Int, dimension: Int)
    {
        self.name = Renderer.nameWith(duration: duration, dimension: dimension)
        self.image = Renderer.imageWith(duration: duration, dimension: dimension)
    }
    
    func createFile(basePath: String = Renderer.path)
    {
        FileManager.default.createFile(
            atPath: "\(basePath)/\(name).tiff",
            contents: image.tiffRepresentation,
            attributes: nil)
    }
}
