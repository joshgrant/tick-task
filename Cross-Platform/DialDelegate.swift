//
//  DialDelegate.swift
//  TickTask
//
//  Created by Joshua Grant on 6/10/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

protocol DialDelegate
{
    func dialStartedTracking(dial: Dial)
    func dialStoppedTracking(dial: Dial)
    func dialUpdatedTracking(dial: Dial)
}

protocol DialProtocol
{
    var delegate: DialDelegate? { get set }
    var dialState: DialState { get set }
}
