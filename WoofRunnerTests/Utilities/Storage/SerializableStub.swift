//
//  SerializableStub.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/19/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

@testable import WoofRunner

public class SerializableStub: Serializable {

    public private(set) var id: String

    init(id: String) {
        self.id = id
    }

    public func serialize() -> NSDictionary {
        return ["details": "dummy detail"]
    }

}
