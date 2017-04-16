//
//  StoredGame+DisplayedGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/2/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

extension StoredGame: DisplayedGame {

    public var displayedName: String {
        return name ?? "Rolling Deep"
    }

    public var displayedId: String {
        return uuid!
    }

    public var displayedOwner: String {
        return ownerId ?? ""
    }

    public var editable: Bool {
        return !isDownloaded
    }

    public var uploadable: Bool {
        return false
    }

}
