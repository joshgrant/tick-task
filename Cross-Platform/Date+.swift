//
//  Date+.swift
//  TickTask
//
//  Created by Joshua Grant on 6/11/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

extension Date
{
    var components: DateComponents {
        // Is this time zone safe?
        return Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year, .timeZone], from: self)
    }
}
