//
//  FractalsTests.swift
//  FractalsTests
//
//  Created by David Garcia on 4/6/19.
//  Copyright © 2019 Ayy Lmao LLC. All rights reserved.
//

import XCTest
@testable import Fractals

class FractalsTests: XCTestCase {

    var tree: Tree?
    let rect = NSRect(x: 0, y: 0, width: 500, height: 500)
    override func setUp() {
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateController(withIdentifier: "treeView") as! TreeViewController
        assert(viewController != nil)
        tree = viewController.treeView
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            tree?.drawBranch(x1: 0, y1: 0, angle: 30, depth: 10)
            // Put the code you want to measure the time of here.
        }
    }

}
