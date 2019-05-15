//
//  DurationTests.swift
//  PlannerTests
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import XCTest
@testable import Planner

class DurationTests: XCTestCase {

    var duration: Duration!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberInitializer() {
        duration = Duration(day: 1, hour: 1, minute: 1, second: 1)
        XCTAssert(duration.toSecond() == 90061, "Duration's number initializer is wrong")
    }
    
    func testStringInitializer() {
        do {
            duration = try Duration(durationString: "P")
            XCTAssert(duration.toSecond() == 0, "Duration's string initializer: P")
        } catch {
            XCTAssert(true, "un-exepected exception")
        }
        
        do {
            duration = try Duration(durationString: "P1D1H1M1S")
            XCTAssert(duration.toSecond() == 90061, "Duration's string initializer: P1D1H1M1S")
        } catch {
            XCTAssert(true, "un-exepected exception")
        }
        
        do {
            duration = try Duration(durationString: "PDHMS")
            XCTAssert(duration.toSecond() == 0, "Duration's string initializer: PDHMS")
        } catch {
            XCTAssert(true, "un-exepected exception")
        }
        
        do {
            duration = try Duration(durationString: "P1DAH1M1S")
            XCTAssert(true, "Duration's string initializer: P1DAH1M1S")
        } catch {
            // expected exception
        }
        
        do {
            duration = try Duration(durationString: "P1D1H1D1M1S")
            XCTAssert(true, "Duration's string initializer: P1D1H1D1M1S")
        } catch {
            // expected exception
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
