//
//  RandomLinesTest.swift
//  FractalsTests
//
//  Created by David Garcia on 5/7/19.
//  Copyright © 2019 Ayy Lmao LLC. All rights reserved.
//

import XCTest
@testable import Fractals

class RandomLinesTest: XCTestCase {
    var lines: RandomLines?

    override func setUp() {
        lines = RandomLines(frame: NSRect(x: 0, y: 0, width: 500, height: 800))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            lines?.drawLines()
        }
    }

}
