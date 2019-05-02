//
//  DurationFormatter.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 4/24/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

class DurationFormatter: NumberFormatter
{
    override func string(from number: NSNumber) -> String? {
        return "Hello"
    }
    
    override func number(from string: String) -> NSNumber? {
        return NSNumber(value: 100)
    }
    
//    func string(from number: Double) -> String?
//    {
//        let hours = floor(number / 360.0)
//        let minutes = floor(number / 60.0)
//        let seconds = remainder(number, 60.0)
//
//        return "\(hours.string(fractionDigits: 0))h \(minutes.string(fractionDigits: 0))m \(seconds.string(fractionDigits: 0))s"
//    }
//
//    // Converts a string in the format (num)h (num)m (num)s
//    // Where each component is optional.
//    // Then, takes the values and converts them into a time interval of seconds
//    func number(from string: String) -> Double
//    {
////        let parts = string.components(separatedBy: CharacterSet(charactersIn: " "))
////
////        for part in parts
////        {
////            let index = part.index(part.startIndex, offsetBy: part.count - 1)
////            let stringRemovingSuffix = string[..<index]
////
////
////        }
//
//        return 100
//    }
}

extension Double
{
    func string(fractionDigits: Int) -> String
    {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
