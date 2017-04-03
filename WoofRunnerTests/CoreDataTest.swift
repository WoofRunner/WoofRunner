//
//  CoreDataTest.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import XCTest
@testable import WoofRunner

class CoreDataTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let cdm = CoreDataManager.getInstance()

        let game = StoredGame(context: cdm.context)
        game.uuid = "123"

        for _ in 0..<10 {
            let obstacle = StoredObstacle(context: cdm.context)
            game.addToObstacles(obstacle)
        }

        XCTAssertEqual(game.obstacles?.count, 10)
    }

}
