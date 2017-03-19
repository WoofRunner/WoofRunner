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

    func testUploadGame() {
        let stub = SerializableStub(id: "123")
        osm.save(stub)

        let expect = expectation(description: "Correct game should be loaded from Firebase")
        osm.load("123")
            .onSuccess { loadedGame in
                XCTAssertEqual(loadedGame?["id"] as? String, "123", "ID should be the same")
                expect.fulfill()
            }
            .onFailure { error in
                XCTFail("Failure block should not be called")
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

}
