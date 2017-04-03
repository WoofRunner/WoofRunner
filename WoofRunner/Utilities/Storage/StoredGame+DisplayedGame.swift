//
//  StoredGame+DisplayedGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/2/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

extension StoredGame: DisplayedGame {

    public var id: String {
        return uuid!
    }

    public var owner: String {
        return ownerId ?? ""
    }

}
