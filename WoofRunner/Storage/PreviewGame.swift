//
//  PreviewGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/30/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/**
 Immuatable struct for games downloaded from the online marketplace.
 */
public struct PreviewGame {

    public let uuid: String
    public let name: String
    public let ownerID: String
    public let ownerName: String
    public let createdAt: Date
    public let updatedAt: Date

}

extension PreviewGame: DisplayedGame {

    public var displayedOwner: String {
        return ownerName
    }

    public var displayedId: String {
        return uuid
    }

    public var displayedName: String {
        return name
    }

    public var editable: Bool {
        return true
    }

    public var uploadable: Bool {
        return true
    }

}
