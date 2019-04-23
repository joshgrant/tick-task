//
//  ViewController.swift
//  TickTask
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{
    var secondTimer: Timer?
    
    override func viewDidLoad()
    {
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        secondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(secondTimerUpdated(_:)), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
    }
    
    @objc func secondTimerUpdated(_ timer: Timer)
    {
        print("Hello, world!")
    }
    
    // func tapButtonDidStart()
    
    // func tapButtonDidStop()
    
    // func totalDurationForTaskGroup(taskGroup: TaskGroup) -> TimeInterval
    
    // func autocompleteSuggestionsForSegment(segment: String) -> [String]?
    
    // func updateDurationLabelWithTimeInterval(timeInterval: TimeInterval)
    
    // func currentCountdownTimerValue() -> TimeInterval
    
    // func startCountdownTimer()
    
    // func pauseCountdownTimer()
    
    // func countdownTimerDidComplete(timer: Timer)
    
    // func createNewTaskGroup(name: String) -> TaskGroup
    
    // func allTaskGroups() -> [TaskGroup]
    
    // func deleteTaskGroup(taskGroup: TaskGroup)
    
    // func renameTaskGroup(taskGroup: TaskGroup, new name: String)
    
    // func textFieldDidUpdateText(textField: NSTextField)
    // Recalculate the autocomplete suggestions for the segment
    
    // func textFieldDidFinishEditing(textField: NSTextField)
    // Find a perfect match (case-insensitive) or create a new task group
    
    // func setEnabledStateOfTextFields(enabled: Bool)
    
    // func saveDatabase()
    
    // func populateTaskNameFieldWithLastSavedTaskName()
    
    // func populateTaskDurationFieldWithLastSavedDuration()
    
    // func saveTaskGroupNameBeforeQuit()
    
    // func saveTaskDurationBeforeQuit()
    
    // func setTooltipForTaskNameField
    
    // func displayAutocompleteDropdownList()
    
    // func hideAutocompleteDropdownList()
    
    // func highlightSelectedDropdownRow(highlighted: Bool)
    
    // func navigateToPreviousAutocompleteSuggestion()
    
    // func navigateToNextDropdownRow()
    
    // func autocompleteSuggestionSelected(suggestion: String)
    // Use the suggestion from the autocomplete

    // func showRightClickMenuOnDropdownList()
    
    // func hideRightClickMenuOnDropdownList()
    
    // func handleTabToNextInterfaceElement()
    
    // func handleEnterKeyPress()
    // If the button is selected - start or stop
    // If an autocomplete suggestion is selected - change the current task
}

