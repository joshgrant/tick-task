//
//  Dimension.swift
//  TickTask-ReleaseAssets
//
//  Created by Joshua Grant on 5/28/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

enum Orientation
{
    case landscape
    case portrait
}

struct Size
{
    var width: Int
    var height: Int
    
    var orientation: Orientation {
        return width > height ? .landscape : .portrait
    }
    
    var cgSize: CGSize {
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    init(width: Int, height: Int)
    {
        self.width = width
        self.height = height
    }
}

enum SizeClass
{
    case appleWatch
    case appleTV
    case mac
    case iPad
    case iPhoneX
    case iPhone
}

extension SizeClass: RawRepresentable
{
    typealias RawValue = Size
    
    init?(rawValue: RawValue)
    {
        switch (rawValue.width, rawValue.height)
        {
        case (368, 448): self = .appleWatch
        case (3840, 2160): self = .appleTV
        case (2880, 1800): self = .mac
        case (2048, 2732): self = .iPad
        case (1242, 2208): self = .iPhone
        case (1242, 2688): self = .iPhoneX
        default:
            return nil
        }
    }
    
    var rawValue: RawValue
    {
        switch self
        {
        case .appleWatch:
            return Size(width: 368, height: 448)
        case .appleTV:
            return Size(width: 3840, height: 2160)
        case .mac:
            return Size(width: 2880, height: 1800)
        case .iPad:
            return Size(width: 2048, height: 2732)
        case .iPhone:
            return Size(width: 1242, height: 2208)
        case .iPhoneX:
            return Size(width: 1242, height: 2688)
        }
    }
}
