//
//  LMHomeViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/27/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import RxSwift

public class LMHomeViewModel {

    // MARK: - Public variables

    public var featuredGames = Variable<[SaveableStub]>([])
    public var isLoading = Variable<Bool>(false)

    // MARK: - Private variables

    private let osm = OnlineStorageManager.getInstance()

    // MARK: - Public methods

    public func loadFeaturedGames() {
        // TODO: Map only games that user have not downloaded
        osm.loadAll()
            .onSuccess { games in
                let loadedGames = games!
                for (uuid, _) in loadedGames {
                    // TODO: Proper mapping of game object
                    let mappedGame = SaveableStub(uuid: uuid as! String)
                    self.featuredGames.value.append(mappedGame)
                }
        }
    }

}
