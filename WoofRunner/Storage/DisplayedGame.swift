//
//  DisplayedGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/2/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

/**
 Protocol that specifies contract for all games that could be displayed to the user.
 */
public protocol DisplayedGame {

    var displayedId: String { get }
    var displayedOwner: String { get }
    var displayedName: String { get }
    var editable: Bool { get }
    var uploadable: Bool { get }

}
