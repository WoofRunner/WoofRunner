//
//  OnlineStorageManagerTests.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/19/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import XCTest

@testable import WoofRunner

class OnlineStorageManagerTests: XCTestCase {

    let osm = OnlineStorageManager.getInstance()

    override func tearDown() {
        osm.clear()
    }

    func testUploadGame() {
        let stub = SaveableStub(uuid: "123")
        osm.save(stub)

        let expect = expectation(description: "Correct game should be loaded from Firebase")
        osm.load("123")
            .onSuccess { loadedGame in
                XCTAssertEqual(loadedGame?["details"] as? String, "dummy detail",
                               "Content of object should be the same")
                expect.fulfill()
            }
            .onFailure { error in
                XCTFail("Failure block should not be called")
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadGame() {
        let expect = expectation(description: "No games should be loaded when Firebase is empty")
        osm.load("123")
            .onSuccess { loadedGame in
                XCTAssertNil(loadedGame, "No games should be loaded")
                expect.fulfill()
            }
            .onFailure { error in
                XCTFail("Failure block should not be called")
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

}
