//
//  SerializableStub.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/19/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

@testable import WoofRunner

public class SerializableStub: Serializable {

    public private(set) var id: String

    init(id: String) {
        self.id = id
    }

    public func serialize() -> Dictionary<String, Any> {
        return ["details": "dummy detail"]
    }

}
