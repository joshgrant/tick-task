//
//  DialMenuItem.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/5/19.
//

import Cocoa

class DialMenuItem
{
    var delegate: DialDelegate?
    
    var label: NSTextField
    var slider: NSSlider
    var dial: Dial
    var stackView: NSStackView
//    var containerView: NSView
    var menuItem: NSMenuItem
    
    init(delegate: DialDelegate, width: CGFloat)
    {
        label = NSTextField(labelWithString: defaultInterval.durationString)
        label.alignment = .center
        label.font = NSFont.systemFont(ofSize: 16, weight: .medium)
        
        dial = Dial()
        dial.minValue = 0
        dial.maxValue = 3600
        dial.sliderType = .circular
        dial.delegate = delegate
        
        slider = NSSlider()
        slider.cell = dial
        
        slider.addConstraint(NSLayoutConstraint(item: slider, attribute: .width, relatedBy: .equal, toItem: slider, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        stackView = NSStackView(views: [label, slider])
        stackView.edgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        stackView.orientation = .vertical
        stackView.alignment = .centerX
        stackView.distribution = .fill
        stackView.spacing = 10
        
        stackView.autoresizingMask = [.width, .height]
        stackView.autoresizesSubviews = true
        
        stackView.addConstraint(NSLayoutConstraint(item: slider,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: width - stackView.spacing * 4))
        
        menuItem = NSMenuItem(title: "Dial", action: nil, keyEquivalent: "")
        menuItem.view = stackView
    }
    
    func configureLabel(interval: Double)
    {
        label.stringValue = interval.durationString
    }
    
    func configureDial(totalInterval: Double, rotations: Int)
    {
        guard let dialView = dial.controlView else { return }
        
        dial.doubleValue = totalInterval - Double(rotations) * 3600
        
        dialView.setNeedsDisplay(dialView.frame)
    }
}
