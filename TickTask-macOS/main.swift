//
//  main.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/6/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Cocoa

NSApplication.shared.setActivationPolicy(.accessory)

let delegate = AppDelegate()

NSApplication.shared.delegate = delegate

NSApplication.shared.run()

//NSApplication.shared.finishLaunching()
