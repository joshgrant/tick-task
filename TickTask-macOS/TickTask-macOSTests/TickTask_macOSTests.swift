//
//  TickTask_macOSTests.swift
//  TickTask-macOSTests
//
//  Created by Joshua Grant on 5/10/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import XCTest

class TickTask_macOSTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTimeIntervalMinutes()
    {
        let timeInterval: TimeInterval = 1000
        
        XCTAssertEqual(timeInterval.minutes, 60, "Maybe a rounding error")
    }
}
