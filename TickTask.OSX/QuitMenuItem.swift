//
//  QuitMenuItem.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/5/19.
//

import Cocoa

class QuitMenuItem: NSMenuItem
{
    convenience init()
    {
        self.init(title: "quit_ticktask".localized,
                  action: #selector(NSApplication.terminate(_:)),
                  keyEquivalent: "q")
    }
}
