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

    public var featuredGames = Variable<[StoredGame]>([])
    public var isLoading = Variable<Bool>(false)

    // MARK: - Private variables

    private let gsm = GameStorageManager.getInstance()
    private let disposeBag = DisposeBag()

    // MARK: - Initializers

    public init() {
        observeFeaturedGames()
    }

    // MARK: - Public methods

    public func observeFeaturedGames() {
        featuredGames.value = gsm.getAllGames()

        // TODO: Map only games that user have not downloaded from Firebase
        // Currently stubbed to test CoreData implementation
        gsm.games.asObservable()
            .map { $0.values }
            .subscribe(onNext: { self.featuredGames.value = $0.map { $0 } })
            .addDisposableTo(disposeBag)
    }

}
