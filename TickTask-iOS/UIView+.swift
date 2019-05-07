//
//  UIView+.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/5/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit

extension UIView
{
    var center: CGPoint {
        get {
            return CGPoint(x: self.bounds.size.width / 2.0,
                           y: self.bounds.size.height / 2.0)
        }
    }
}
