//
//  SaveableStub.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/12/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

@testable import WoofRunner

/**
 Stub object for Saveable
 */
public class SaveableStub {

    public private(set) var uuid: String


    init(uuid: String) {
        self.uuid = uuid
    }

}

extension SaveableStub: SaveableGame {
    public var obstacles: [SaveableObstacle] {
        get {
            return []
        }
    }

    public func serialize() -> Dictionary<String, Any> {
        return [
            "details": "dummy detail"
        ]
    }
}

extension SaveableStub: UploadableGame {
    public var ownerID: String {
        get {
            return "owner123"
        }
    }
}
