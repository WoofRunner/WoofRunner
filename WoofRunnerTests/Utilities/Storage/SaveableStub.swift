//
//  SaveableStub.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/12/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import ObjectMapper
@testable import WoofRunner

/**
 Stub object for Saveable
 */
public class SaveableStub: SaveableGame {

    public var uuid: String
    public var ownerID: String
    public var obstacles: [SaveableObstacle]
    public var platforms: [SaveablePlatform]
    public var createdAt: Date
    public var updatedAt: Date

    public required convenience init?(map: Map) {
        let uuid: String = try! map.value("uuid")
        self.init(uuid: uuid)
    }

    public init(uuid: String) {
        self.uuid = uuid
        self.createdAt = Date()
        self.updatedAt = Date()

        self.ownerID = "123"
        self.obstacles = []
        self.platforms = []
    }

}

extension SaveableStub: UploadableGame {

    public func mapping(map: Map) {
        uuid <- map["uuid"]
        ownerID <- map["ownerID"]
        createdAt <- (map["createdAt"], DateTransform())
        updatedAt <- (map["updatedAt"], DateTransform())
        obstacles <- map["obstacles"]
        platforms <- map["platforms"]
    }

}
