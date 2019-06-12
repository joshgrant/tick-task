//
//  TriangleView.swift
//  TickTask
//
//  Created by Joshua Grant on 6/12/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

class TriangleView: NSView
{
    var topView: NSView?
    var bottomLeftView: NSView?
    var bottomRightView: NSView?
    
    var maxSquare: CGFloat = 100
    var minSquare: CGFloat = 30
    var spacing: CGFloat = 10
    
    init(topView: NSView?, bottomLeftView: NSView?, bottomRightView: NSView?, width: CGFloat)
    {
        self.topView = topView
        self.bottomLeftView = bottomLeftView
        self.bottomRightView = bottomRightView
        
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: width))
        
        if let topView = self.topView
        {
            self.addSubview(topView)
        }
        
        if let bottomLeftView = self.bottomLeftView
        {
            self.addSubview(bottomLeftView)
        }
        
        if let bottomRightView = self.bottomRightView
        {
            self.addSubview(bottomRightView)
        }
        
        configureAutoLayoutConstraints(width: width)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("Why, apple?")
    }
    
    func configureAutoLayoutConstraints(width: CGFloat)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: width))
        
        let baseOfBisectingTriangle = self.bounds.size.width / 2
        let hypotenuseOfBisectingTriangle = self.bounds.size.width
        
        let heightOfIsocelesTriangle = (hypotenuseOfBisectingTriangle.squared - baseOfBisectingTriangle.squared).squareRoot()
        
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: heightOfIsocelesTriangle))
        
        topViewConstraints(width: width)
        bottomLeftViewConstraints()
        bottomRightViewConstraints()
    }
    
    func topViewConstraints(width: CGFloat)
    {
        if let topView = topView
        {
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: topView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
        
        self.addConstraint(NSLayoutConstraint(item: topView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: spacing))
        
        topView.addConstraint(NSLayoutConstraint(item: topView,
                                                 attribute: .height, relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: maxSquare))
        
        topView.addConstraint(NSLayoutConstraint(item: topView,
                                                 attribute: .width, relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: maxSquare))
        }
    }
    
    func bottomLeftViewConstraints()
    {
        if let bottomLeftView = bottomLeftView
        {
        bottomLeftView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: bottomLeftView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: spacing))
        
        self.addConstraint(NSLayoutConstraint(item: bottomLeftView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: -spacing))
        
        bottomLeftView.addConstraint(NSLayoutConstraint(item: bottomLeftView,
                                                        attribute: .height, relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1.0,
                                                        constant: minSquare))
        
        bottomLeftView.addConstraint(NSLayoutConstraint(item: bottomLeftView,
                                                        attribute: .width, relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1.0,
                                                        constant: minSquare))
        }
    }
    
    func bottomRightViewConstraints()
    {
        if let bottomRightView = bottomRightView
        {
            bottomRightView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addConstraint(NSLayoutConstraint(item: bottomRightView,
                                                  attribute: .trailing,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .trailing,
                                                  multiplier: 1.0,
                                                  constant: -spacing))
            
            self.addConstraint(NSLayoutConstraint(item: bottomRightView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: -spacing))
            
            bottomRightView.addConstraint(NSLayoutConstraint(item: bottomRightView,
                                                             attribute: .height, relatedBy: .equal,
                                                             toItem: nil,
                                                             attribute: .notAnAttribute,
                                                             multiplier: 1.0, constant: minSquare))
            bottomRightView.addConstraint(NSLayoutConstraint(item: bottomRightView,
                                                             attribute: .width, relatedBy: .equal,
                                                             toItem: nil,
                                                             attribute: .notAnAttribute,
                                                             multiplier: 1.0, constant: minSquare))
        }
    }
}
