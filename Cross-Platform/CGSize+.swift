//
//  CGSize+.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreGraphics

extension CGSize
{
    init(square: CGFloat)
    {
        self.init(width: square, height: square)
    }
}
