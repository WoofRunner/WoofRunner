//
//  LMHomeViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/27/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import RxSwift

public struct LMHomeViewModel {

    // MARK: - Public variables

    public private(set) var games = Variable<[DisplayedGame]>([])
    public private(set) var failure = Variable<Bool>(false)

    // MARK: - Public methods

    public mutating func setGames(_ games: [PreviewGame]) {
        self.games.value = games
    }

    public mutating func setFailure(_ failure: Bool) {
        self.failure.value = failure
    }

    public func viewModelForGame(at index: Int) -> LevelCardViewModel {
        guard index < games.value.count else {
            fatalError("Index is more than the number of games loaded in LMHomeViewModel")
        }

        return LevelCardViewModel(game: games.value[index])
    }

}
