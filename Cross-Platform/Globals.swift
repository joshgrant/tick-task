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

// MARK: Notifications
#if DEBUG
let notificationIdentifier = "me.joshgrant.TickTask-TimeUpNotificationDebug"
#else
let notificationIdentifier = "me.joshgrant.TickTask-TimeUpNotification"
#endif

// MARK: Defaults
let defaultInterval: Double = 0
