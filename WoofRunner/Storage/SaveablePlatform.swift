//
//  SaveablePlatform.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

public protocol SaveablePlatform {
    func toStoredPlatform() -> StoredPlatform
}
