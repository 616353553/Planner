//
//  CustomTaskTests.swift
//  PlannerTests
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import XCTest
@testable import Planner

class CustomTaskTests: XCTestCase {

    var tasks = [CustomTask]()
    let currentDate = Date()
    
    override func setUp() {
        super.setUp()
        for i in 0...2 {
            let name = "task name \(i)"
            let priority = i
            let description = "task description \(i)"
            let durationEstimate = Duration(day: 0, hour: 1, minute: 0, second: 0)
            tasks.append(CustomTask(name: name, priority: priority, description: description, deadline: currentDate, durationEstimate: durationEstimate))
        }
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCompareCustomTask() {
        XCTAssert(tasks[0] < tasks[1], "tasks[0] is less urgent than tasks[1]")
        
        tasks[0].setPriority(priority: 1)
        XCTAssert(tasks[0] == tasks[1], "tasks[0] is equal to tasks[1]")
        
        tasks[0].setPriority(priority: 2)
        XCTAssert(tasks[0] > tasks[1], "tasks[0] is more urgent than tasks[1]")
        
        tasks[0].setDeadline(deadline: currentDate.addingTimeInterval(1))
        XCTAssert(tasks[0] < tasks[1], "tasks[0] is less urgent than tasks[1]")
        
        tasks[0].setDeadline(deadline: currentDate.addingTimeInterval(-1))
        XCTAssert(tasks[0] > tasks[1], "tasks[0] is more urgent than tasks[1]")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
