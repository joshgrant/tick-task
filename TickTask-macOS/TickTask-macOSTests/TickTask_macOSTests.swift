//
//  TickTask_macOSTests.swift
//  TickTask-macOSTests
//
//  Created by Joshua Grant on 5/10/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import XCTest
@testable import Tick_Task

class TickTask_macOSTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

// MARK: Time Interval
extension TickTask_macOSTests
{
    func testTimeIntervalMinutes()
    {
        var timeInterval: TimeInterval = 1000
        XCTAssertEqual(timeInterval.minutes, 16, "")
        
        timeInterval = -500
        XCTAssertEqual(timeInterval.minutes, -8, "")
        
        timeInterval = 0
        XCTAssertEqual(timeInterval.minutes, 0, "")
        
        timeInterval = 20.02
        XCTAssertEqual(timeInterval.minutes, 0, "")
    }
    
    func testTimeIntervalSeconds()
    {
        var timeInterval: TimeInterval = 800
        XCTAssertEqual(timeInterval.seconds, 20, "")
        
        timeInterval = 150.232
        XCTAssertEqual(timeInterval.seconds, 30, "")
        
        timeInterval = -1003
        XCTAssertEqual(timeInterval.seconds, -43, "")
        
        timeInterval = 0
        XCTAssertEqual(timeInterval.seconds, 0, "")
    }
    
    func testTimeIntervalToAngle()
    {
        var timeInterval: TimeInterval = 0
        XCTAssertEqual(timeInterval.toAngle(), 0, accuracy: 0.001, "")
        XCTAssertEqual(timeInterval.toAngle(maxMinutes: 100), 0, accuracy: 0.001, "")
        
        // Testing 15 minutes - should be PI / 2
        timeInterval = 900
        XCTAssertEqual(timeInterval.toAngle(), -CGFloat.pi * 0.5, accuracy: 0.001, "")
        XCTAssertEqual(timeInterval.toAngle(maxMinutes: 20), -CGFloat.pi * 1.5, accuracy: 0.001, "")
        
        // Testing 45 minutes, should be PI * 1.5
        timeInterval = 2700
        XCTAssertEqual(timeInterval.toAngle(), -CGFloat.pi * 1.5, accuracy: 0.001, "")
        
        // Testing 55 minutes, should be 11PI/6
        timeInterval = 3300
        XCTAssertEqual(timeInterval.toAngle(), -CGFloat.pi * 11 / 6, accuracy: 0.001, "")

        // Testing 5 minutes, should be PI/6
        timeInterval = 300
        XCTAssertEqual(timeInterval.toAngle(), -CGFloat.pi / 6, accuracy: 0.001, "")
        
        timeInterval = -100
        XCTAssertEqual(timeInterval.toAngle(), 0, accuracy: 0.001, "A negative time interval should never exist")
    }
    
    func testAngleToTimeInterval()
    {
        var angle: CGFloat = 0
        XCTAssertEqual(angle.toInterval(), 0, accuracy: 0.001, "")
        
        angle = -CGFloat.pi * 0.5
        XCTAssertEqual(angle.toInterval(), 900, accuracy: 0.001, "")
        
        angle = -CGFloat.pi * 1.5
        XCTAssertEqual(angle.toInterval(), 2700, accuracy: 0.001, "")
        
        angle = -CGFloat.pi * 11 / 6
        XCTAssertEqual(angle.toInterval(), 3300, accuracy: 0.001, "")
        
        angle = -CGFloat.pi / 6
        XCTAssertEqual(angle.toInterval(), 300, accuracy: 0.001, "")
        
        angle = CGFloat.pi
        XCTAssertEqual(angle.toInterval(), 0, accuracy: 0.001, "A positive angle shouldn't exist")
    }
}

// Mark: NSPoint

extension TickTask_macOSTests
{
    func testAngleFromPoint()
    {
        let firstPoint = NSPoint(x: 0, y: 0)
        var secondPoint = NSPoint(x: 1, y: 0)
        
        XCTAssertEqual(secondPoint.angleFromPoint(point: firstPoint), CGFloat.pi * -0.5, accuracy: 0.001, "")
        
        secondPoint = NSPoint(x: 0, y: -1)
        
        XCTAssertEqual(secondPoint.angleFromPoint(point: firstPoint), -CGFloat.pi, accuracy: 0.001, "")
        
        secondPoint = NSPoint(x: -1, y: 0)
        
        XCTAssertEqual(secondPoint.angleFromPoint(point: firstPoint), CGFloat.pi * -1.5, accuracy: 0.001, "")
        
        secondPoint = NSPoint(x: -1, y: sin(CGFloat.pi / 6) / sin(CGFloat.pi / 3))
        
        XCTAssertEqual(secondPoint.angleFromPoint(point: firstPoint), CGFloat.pi * -5/3, accuracy: 0.001, "")
    }
}

// MARK: NSImage

// MARK: NSView

extension TickTask_macOSTests
{
    func testCenter()
    {
        var view = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 100))
        XCTAssertEqual(view.center.x, 150, "")
        XCTAssertEqual(view.center.y, 50, "")
        
        view = NSView(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
        XCTAssertEqual(view.center.x, 0, "")
        XCTAssertEqual(view.center.y, 0, "")
    }
    
    func testTopLevelView()
    {
        let view1 = NSView()
        let view2 = NSView()
        let view3 = NSView()
        let view4 = NSView()
        
        view1.addSubview(view2)
        view2.addSubview(view3)
        view3.addSubview(view4)
        
        XCTAssertEqual(view4.topLevelView, view1, "")
        XCTAssertEqual(view1.topLevelView, view1, "")
        
        view2.removeFromSuperview()
        
        XCTAssertEqual(view4.topLevelView, view2, "")
    }
}
