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

    public let uuid: String
    public let ownerID: String
    public let createdAt: Date
    public let updatedAt: Date

}

extension PreviewGame: DisplayedGame {
    public var id: String {
        return uuid
    }
}
