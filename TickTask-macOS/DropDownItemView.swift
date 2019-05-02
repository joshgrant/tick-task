//
//  DropDownItemView.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/2/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

protocol DropDownDelegate
{
    func dropDownItemWasSelected(item: DropDownItemView)
}

// I know it's not great to have views with funcitonality like this, but if
// it becomes too annoying, we can break out the model logic into a separate
// class...
class DropDownItemView: NSView
{
    @IBOutlet weak var taskNameLabel: NSTextField!
    @IBOutlet weak var taskDurationLabel: NSTextField!
    @IBOutlet weak var selectionButton: NSButton!
    
    var taskGroup: TaskGroup?
    var delegate: DropDownDelegate?
    
    static func initFromNib() -> DropDownItemView?
    {
        var topLevelObjects: NSArray?
        Bundle.main.loadNibNamed("DropDownItemView", owner: self, topLevelObjects: &topLevelObjects)
        
        guard let objects = topLevelObjects else { return nil }
        
        for object in objects
        {
            if let dropDownItemView = object as? DropDownItemView
            {
                return dropDownItemView
            }
        }
        
        return nil
    }
    
    override func touchesBegan(with event: NSEvent) {
        print("Began")
    }
    
    override func touchesEnded(with event: NSEvent) {
        print("Ended")
    }
}
