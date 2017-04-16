//
//  DisplayedGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/2/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

public protocol DisplayedGame {
    var displayedId: String { get }
    var displayedOwner: String { get }
    var displayedName: String { get }
}
