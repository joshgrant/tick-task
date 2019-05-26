//
//  DrawingData.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

struct DrawingData
{
    var scaleFactor: CGFloat
    var padding: CGSize
    var rimThickness: CGFloat
    
    init(rect: CGRect)
    {
        scaleFactor = rect.size.width / 100
        padding = CGSize(square: 6.64 * scaleFactor)
        rimThickness = 1.76 * scaleFactor
    }
}
