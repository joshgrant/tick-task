//
//  Globals.swift
//  TickTask
//
//  Created by Joshua Grant on 6/6/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

// MARK: Open At Login
#if DEBUG
let autoOpenKey = "me.joshgrant.TickTask.isAutoOpenDebug"
let launcherKey = "me.joshgrant.TickTask-macOSLauncherDebug"
#else
let autoOpenKey = "me.joshgrant.TickTask.isAutoOpen"
let launcherKey = "me.joshgrant.TickTask-macOSLauncher"
#endif

// MARK: Defaults
let defaultInterval: Double = 0

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
