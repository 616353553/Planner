//
//  TaskTests.swift
//  PlannerTests
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import XCTest
@testable import Planner

class TaskTests: XCTestCase {

    var task: Task!
    
    override func setUp() {
        super.setUp()
        let name = "task name 1"
        let description = "task description 1"
        var deadline = Date()
        deadline.addTimeInterval(7 * 24 * 3600)
        let duration = Duration(day: 5, hour: 0, minute: 0, second: 0)
        task = Task(name: name, description: description, deadline: deadline, durationEstimate: duration)
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTaskDue() {
        var currentDate = task.getDeadline().addingTimeInterval(-1)
        XCTAssert(!task.isDue(compareTo: currentDate), "Task should not be due")
        
        currentDate = task.getDeadline()
        XCTAssert(task.isDue(compareTo: currentDate), "Task should be due")
        
        currentDate = task.getDeadline().addingTimeInterval(1)
        XCTAssert(task.isDue(compareTo: currentDate), "Task should be due")
 
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
