//
//  Platform.swift
//  TickTask
//
//  Created by Joshua Grant on 6/11/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

enum Platform: String
{
    case iOS = "me.joshgrant.TickTask.iOS.alarmDate"
    case iOSDebug = "me.joshgrant.TickTask.iOS.Debug.alarmDate"
    case OSX = "me.joshgrant.TickTask.OSX.alarmDate"
    case OSXDebug = "me.joshgrant.TickTask.OSX.Debug.alarmDate"
    
    static var current: Platform
    {
        #if os(iOS)
        #if DEBUG
        return .iOSDebug
        #else
        return .iOS
        #endif
        #elseif os(OSX)
        #if DEBUG
        return .OSXDebug
        #else
        return .OSX
        #endif
        #endif
    }
    
    static var other: Platform
    {
        switch current
        {
        case .iOS: return .OSX
        case .iOSDebug: return .OSXDebug
        case .OSX: return .iOS
        case .OSXDebug: return .iOSDebug
        }
    }
}
