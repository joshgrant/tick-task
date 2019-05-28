//
//  CGRect+.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreGraphics

extension CGRect
{
    var center: CGPoint {
        return CGPoint(x: self.origin.x + self.size.width / 2,
                       y: self.origin.y + self.size.height / 2)
    }
}
