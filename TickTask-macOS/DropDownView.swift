//
//  DropDownView.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/2/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

class DropDownView: NSView
{
    @IBOutlet weak var stackView: NSStackView!
    
    var delegate: DropDownDelegate?
    
    // It would be nice to add this as a generic extension on the NSView class
    // We could convert the class name to a string, and check against the class
    // type. Worth a shot at some point
    static func initFromNib() -> DropDownView?
    {
        var topLevelObjects: NSArray?
        Bundle.main.loadNibNamed("DropDownView", owner: self, topLevelObjects: &topLevelObjects)
        
        guard let objects = topLevelObjects else { return nil }
        
        for object in objects
        {
            if let dropDownView = object as? DropDownView
            {
                return dropDownView
            }
        }
        
        return nil
    }
    
    func handleNewText(text: String)
    {
//        let fetchRequest: NSFetchRequest<TaskGroup> = TaskGroup.fetchRequest()
        let groups = TaskGroup.taskGroupsMatchingAutocompleteSegment(segment: text)
        
        for view in self.stackView.subviews
        {
            self.stackView.removeView(view)
        }
        
        for group in groups
        {
            if let newDropDownView = DropDownItemView.initFromNib()
            {
                newDropDownView.delegate = self
                newDropDownView.taskGroup = group
                newDropDownView.taskNameLabel.stringValue = group.name ?? ""
                newDropDownView.taskDurationLabel.stringValue = "\(group.totalDuration)"
                self.stackView.addView(newDropDownView, in: .bottom)
            }
        }
    }
    
    override func touchesBegan(with event: NSEvent)
    {
        print("Hwel")
    }
}

// Does it suck that I'm using the same delegate for the parent
// and the child class and the child forwards the event to the parent
// which forwards it to the view controller? I don't think it's a great design
// but it decouples the item view from the list view...
extension DropDownView: DropDownDelegate
{
    func dropDownItemWasSelected(item: DropDownItemView)
    {
        self.delegate?.dropDownItemWasSelected(item: item)
    }
}
