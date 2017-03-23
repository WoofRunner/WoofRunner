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
public class SaveableStub: Saveable {

    public private(set) var uuid: String

    init(uuid: String) {
        self.uuid = uuid
    }
    
}
