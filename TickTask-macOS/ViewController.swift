//
//  ViewController.swift
//  TickTask
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, DialViewDelegate, BackgroundViewDelegate
{
    // MARK: Properties
    var statusItem: NSStatusItem?
    
    // MARK: Interface Outlets
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var dialView: DialView!
    @IBOutlet weak var faceView: FaceView!
    @IBOutlet weak var label: NSTextField!
    
    // MARK: View Lifecycle
    override func viewDidLoad()
    {
        if let view = self.view as? BackgroundView
        {
            view.delegate = self
        }
        
//        if let window = self.view.window
//        {
//            print("window: \(window)")
//            window.acceptsMouseMovedEvents = true
//        }
//        
        self.dialView.delegate = self
        
        self.configureInterfaceElements(state: .inactive)
        requestAuthorizationToDisplayNotifications()
        
//        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved, .mouseExited, .mouseEntered]) { (event) -> NSEvent? in
//            print("Local")
////            print(event)
//            return event
//        }
//
//        NSEvent.addGlobalMonitorForEvents(matching: .any) { (event) in
//            print("Global")
////            print(event)
//        }
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        print(self.view)
    }
    
    // MARK: Background View Delegate
    
    func backgroundViewMouseEvent(_ event: NSEvent)
    {
        handlePanGesture(with: event)
    }
    
    // MARK: Dial View Delegate
    
    func dialViewAngleDurationUpdate(angle: CGFloat) { }
}

// MARK: Gesture
extension ViewController
{
    func handlePanGesture(with event: NSEvent)
    {
        let viewLocation = self.view.topLevelView.convert(event.locationInWindow, to: dialView)
            .applying(CGAffineTransform(translationX: 0, y: -dialView.frame.size.height))
            .applying(CGAffineTransform(scaleX: 1, y: -1))
        
//        print(viewLocation)
        
        let origin = dialView.frame.center
        let snap: CGFloat = event.rightMouseOrModifierKey ? 60 : 12
        let angle: CGFloat = viewLocation.angleFromPoint(point: origin, snapTo: snap)
        
        ViewController.lastAngle = angle
        
        invalidateTimersAndDates()
        
        switch event.type
        {
        case .leftMouseDown, .rightMouseDown:
            userBeganDragging(angle: angle)
        case .leftMouseDragged, .rightMouseDragged:
            configureInterfaceElements(state: .selected, angle: angle)
            
            startInactivityTimer()
            
        case .leftMouseUp, .rightMouseUp:
            userEndedDragging(angle: angle)
        default:
            debugPrint("Event type not handled")
        }
    }
}
