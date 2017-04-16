//
//  PreviewGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/30/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/**
 Immuatable preview game.
 */
public struct PreviewGame {

    fileprivate let stubNames: [String: String] = [
        "10211159909647484": "Lim Ta Eu",
        "1656664861013823": "Sam",
        "10155040752934404": "Jane"
    ]

    public let uuid: String
    public let name: String
    public let ownerID: String
    public let createdAt: Date
    public let updatedAt: Date

}

extension PreviewGame: DisplayedGame {

    public var owner: String {
        guard let owner = stubNames[ownerID] else {
            return "Jane"
        }

        return owner
    }

    public var id: String {
        return uuid
    }

    public var displayedName: String {
        return name
    }

}
