//
//  String+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 5/11/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import Foundation

extension String
{
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
