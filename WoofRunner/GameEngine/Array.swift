//
//  Array.swift
//  WoofRunner
//
//  Created by limte on 22/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
