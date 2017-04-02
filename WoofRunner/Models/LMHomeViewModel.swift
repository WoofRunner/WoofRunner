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

    public private(set) var featuredGames = Variable<[DisplayedGame]>([])
    public private(set) var failure = Variable<Bool>(false)

    // MARK: - Private variables

    private let gsm = GameStorageManager.getInstance()
    private let disposeBag = DisposeBag()

    // MARK: - Initializers

    public init() {
        loadGames()
    }

    // MARK: - Private methods

    /// Loads all games from Core Data.
    private func loadGames() {
        gsm.getAllGames()
            .onSuccess { games in
                self.featuredGames.value = games
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
                self.failure.value = true
            }
    }

}
