//
//  Serializable.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/17/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

/**
 Class/structs that implement this are able to serialize the object into a dictionary
 */
public protocol Serializable {
    func serialize() -> Dictionary<String, Any>
}
