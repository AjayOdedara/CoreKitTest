//
//  CoreTest.swift
//  CoreKit
//
//  Created by AMIT on 08/07/17.
//  Copyright © 2017 acme. All rights reserved.
//

import XCTest
import CoreKit
class CoreTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testThreeRingView() {
        let threeRings = ThreeRingView()
        DispatchQueue.main.async {
            threeRings.innerRingValue = 1.0
            threeRings.middleRingValue = 1.0
            threeRings.outerRingValue = 1.0
        }
        let _ = expectation(forNotification: RingCompletedNotification, object: nil, handler: nil)
        let _ = expectation(forNotification: AllRingsCompletedNotification, object: nil, handler: nil)
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
}
