//
//  CoreDataManagerTests.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/12/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import XCTest

import BrightFutures
import Result

@testable import WoofRunner

/**
 Test cases for reading/writing to CoreData.
 */
class CoreDataManagerTests: XCTestCase {

    var cdm = CoreDataManager.getInstance()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.cdm.deleteAll()
    }

    func testSaveNewGame() {
        let testUUID = "123"
        let stub = SaveableStub(uuid: testUUID)

        let expect = expectation(description: "Game is saved")
        self.cdm.save(stub)
            .flatMap { self.cdm.load(($0).uuid!) }
            .onSuccess { loadedGame in
                XCTAssertEqual(stub.uuid, loadedGame.uuid, "Saved stub should have the same UUID")
                expect.fulfill()
            }
            .onFailure { error in
                XCTFail("Failure block should not be called")
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSaveExistingGame() {
        let testUUID = "123"
        let stub = SaveableStub(uuid: testUUID)

        let expect = expectation(description: "Game is saved twice with different date")
        self.cdm.save(stub)
            .onSuccess { firstSavedGame in
                self.cdm.save(stub)
                    .onSuccess { secondSavedGame in
                        XCTAssertNotEqual(firstSavedGame.createdAt, secondSavedGame.updatedAt,
                                  "Create time and update time should be different")
                        expect.fulfill()
                }
            }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadInvalidGame() {
        let testUUID = "123"

        let expectNil = expectation(description: "CoreData should expect no games loaded with UUID")
        self.cdm.load(testUUID)
            .onSuccess { loadedGame in
                XCTFail("Success block should not be called")

            }
            .onFailure { error in
                XCTAssertEqual(error, CoreDataManagerError.notFound)
                expectNil.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadExistingGame() {
        let testUUID = "123"
        let stub = SaveableStub(uuid: testUUID)

        let expectLoad = expectation(description: "Should load the correct data")
        self.cdm.save(stub)
            .flatMap { self.cdm.load(($0).uuid!) }
            .onSuccess { loadedGame in
                XCTAssertEqual(testUUID, loadedGame.uuid, "Loaded stub should have the same UUID")
                expectLoad.fulfill()
            }
            .onFailure { error in
                XCTFail("Failure block should not be called")
            }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadAllGamesEmpty() {
        let expectLoad = expectation(description: "Should load empty array")
        self.cdm.loadAll()
            .onSuccess { loadedGames in
                XCTAssertEqual(loadedGames.count, 0, "Empty array should be loaded from cdm")
                expectLoad.fulfill()
            }
            .onFailure { error in
                XCTFail("Failure block should not be called")
            }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadAllGames() {
        let stub1 = SaveableStub(uuid: "1")
        let stub2 = SaveableStub(uuid: "2")
        let stub3 = SaveableStub(uuid: "3")

        let expectLoad = expectation(description: "Should load an array of size 3")
        let futures = [cdm.save(stub1), cdm.save(stub2), cdm.save(stub3)]
        futures.sequence()
            .onSuccess { savedGames in
                self.cdm.loadAll()
                    .onSuccess { loadedGames in
                        XCTAssertEqual(loadedGames.count, savedGames.count,
                                       "\(savedGames.count) games should be loaded")
                        expectLoad.fulfill()
                    }
                    .onFailure { error in
                        XCTFail("Failure block should not be called")
                }
            }

        waitForExpectations(timeout: 5, handler: nil)
    }

}
