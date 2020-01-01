//
//  FakeYelpTests.swift
//  FakeYelpTests
//
//  Created by Stephen Ma on 12/26/19.
//  Copyright © 2019 Stephen Ma. All rights reserved.
//

import XCTest
@testable import FakeYelp

class FakeYelpTests: XCTestCase {
    //MARK: Meal class tests
    func testMealInitialization() {
        let meal1 = Meal.init(name: "name", rating: 1, image: nil)
        XCTAssertNotNil(meal1)
    }
    
    func testMealInitializationNil() {
        let meal2 = Meal.init(name: "", rating: 1, image: nil)
        XCTAssertNil(meal2)
        let meal3 = Meal.init(name: "1", rating: -1, image: nil)
        XCTAssertNil(meal3)
        let meal4 = Meal.init(name: "1", rating: 6, image: nil)
        XCTAssertNil(meal4)
    }
}
