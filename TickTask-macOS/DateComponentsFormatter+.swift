//
//  DateComponentsFormatter+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/12/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

extension DateComponentsFormatter
{
    static var currentDurationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    static var completedDurationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
}
