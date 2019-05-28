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
    // MARK: Shared Properties
    var statusItem: NSStatusItem?
    @IBOutlet weak var statusItemImageView: NSImageView?

    // MARK: Interface Outlets
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var dialView: DialView!
    @IBOutlet weak var faceView: FaceView!
    @IBOutlet weak var label: NSTextField!
    
    // MARK: View Lifecycle
    override func viewDidLoad()
    {
        dialView.delegate = self
        self.configureInterfaceElements(state: .inactive)
        requestAuthorizationToDisplayNotifications()
        
        super.viewDidLoad()
    }
}

// MARK: Dial View Delegate
extension ViewController: DialViewDelegate
{
    func dialViewMouseEvent(_ event: NSEvent)
    {
        handlePanGesture(with: event)
    }
}

// MARK: Gesture
extension ViewController
{
    func handlePanGesture(with event: NSEvent)
    {
        let viewLocation = self.view.topLevelView.convert(event.locationInWindow, to: dialView)
            .applying(CGAffineTransform(translationX: 0, y: -dialView.frame.size.height))
            .applying(CGAffineTransform(scaleX: 1, y: -1))
        
        let origin = dialView.frame.center
        let snap: CGFloat = event.rightMouseOrModifierKey ? 60 : 12
        let angle: CGFloat = viewLocation.angleFromPoint(point: origin, snapTo: snap)

        switch event.type
        {
        case .leftMouseDown, .rightMouseDown:
            userBeganDragging(angle: angle)
        case .leftMouseDragged, .rightMouseDragged:
            configureInterfaceElements(state: .selected, angle: angle)
        case .leftMouseUp, .rightMouseUp:
            userEndedDragging(angle: angle)
        default:
            debugPrint("Event type not handled")
        }
    }
}
