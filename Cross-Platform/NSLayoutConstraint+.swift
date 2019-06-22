//
//  NSLayoutConstraint+.swift
//  TickTask
//
//  Created by Joshua Grant on 6/11/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

extension NSLayoutConstraint
{
    static func width(item: Any, width: CGFloat) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: item,
                                  attribute: .width,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  multiplier: 1.0,
                                  constant: width)
    }
    
    static func centerY(for firstItem: Any, to secondItem: Any) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: firstItem,
                                  attribute: .centerY,
                                  relatedBy: .equal,
                                  toItem: secondItem,
                                  attribute: .centerY,
                                  multiplier: 1.0, constant: 0.0)
    }
    
    static func centerX(for firstItem: Any, to secondItem: Any) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: firstItem,
                                  attribute: .centerX,
                                  relatedBy: .equal,
                                  toItem: secondItem,
                                  attribute: .centerX,
                                  multiplier: 1.0,
                                  constant: 0.0)
    }
    
    static func squareConstraints(item: Any) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: item,
                                  attribute: .width,
                                  relatedBy: .equal,
                                  toItem: item,
                                  attribute: .height,
                                  multiplier: 1.0,
                                  constant: 0.0)
    }
    
    static func contstraints(for child: Any, in parent: Any, padding: CGFloat = 0) -> [NSLayoutConstraint]
    {
        return [
            NSLayoutConstraint(item: child,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: padding),
            NSLayoutConstraint(item: child,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: padding),
            NSLayoutConstraint(item: child,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: padding),
            NSLayoutConstraint(item: child,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: padding),
        ]
    }
}
