//
//  main.swift
//  TickTask-macOSLauncher
//
//  Created by Joshua Grant on 5/11/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

#if DEBUG
if NSRunningApplication.runningApplications(withBundleIdentifier: "me.joshgrant.TickTask-macOSDebug").isEmpty
{
    let path = Bundle.main.bundlePath
    var components = path.components(separatedBy: CharacterSet.init(charactersIn: "/"))
    components.removeLast()
    components.append("Tick Task.app")
    NSWorkspace.shared.launchApplication(components.joined(separator: "/"))
}
#else
if NSRunningApplication.runningApplications(withBundleIdentifier: "me.joshgrant.TickTask-macOS").isEmpty
{
    let path = Bundle.main.bundlePath
    var components = path.components(separatedBy: CharacterSet.init(charactersIn: "/"))
    components.removeLast(4)
    NSWorkspace.shared.launchApplication(components.joined(separator: "/"))
}
#endif

NSApplication.shared.terminate(nil)
