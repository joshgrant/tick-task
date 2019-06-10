//
//  DialState.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/26/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

enum DialState: Int
{
    case inactive
    case countdown
    case selected
    
    #if os(OSX)
    var state: NSControl.StateValue {
        switch self {
        case .inactive: return .off
        case .countdown: return .on
        case .selected: return .mixed
        }
    }
    
    static func dialState(from state: NSControl.StateValue) -> DialState
    {
        switch state
        {
        case .off: return .inactive
        case .on: return .countdown
        case .mixed: return .selected
        default:
            return .inactive
        }
    }
    
    #elseif os(iOS)
    var state: UIControl.State {
        switch self
        {
        case .inactive: return .disabled
        case .countdown: return .focused
        case .selected: return .selected
        }
    }
    
    static func dialState(from state: UIControl.State) -> DialState
    {
        switch state
        {
        case .disabled: return .inactive
        case .focused: return .countdown
        case .selected: return .selected
        default:
            return .inactive
        }
    }
    #endif
}
