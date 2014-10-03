//
//  BTConResParser.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/2/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import UIKit
import XCTest
import berlin_transport

class BTConResParserTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        let parser = BTConResParser()
        let connections: [BTConnection] = parser.connections
        XCTAssertGreaterThan(0, connections.count, "What the...?")
    }

    func xtestPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
