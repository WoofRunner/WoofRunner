//
//  LMListViewModel.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/31/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

/**
 View model for LMListView.
 */
public class LMListViewModel {

    // MARK: - Public variables
    public private(set) var listType = Variable<LevelListType>(.Created)
    public private(set) var games = Variable<[DisplayedGame]>([])
    public private(set) var failure = Variable<Bool>(false)

    // MARK: - Private variables

    private let gsm = GameStorageManager.getInstance()
    private let disposeBag = DisposeBag()

    public init() {
        subscribeToListType()
    }

    // MARK: - Public methods

    /// Sets the type of games shown in the current level list view.
    /// - Parameters:
    ///     - listType: LevelListType enum that represents the type of list displayed to the user
    public func setListType(_ listType: LevelListType) {
        self.listType.value = listType
    }

    /// FOR TESTING ONLY.
    /// Creates a dummy game in CoreData.
    public func createOneGame() {
        let stub = LevelGrid()
        gsm.saveGame(stub)
            .flatMap { _ in self.gsm.getAllGames() }
            .onSuccess { games in
                self.games.value = games
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
                self.failure.value = true
        }
    }

    /// FOR TESTING ONLY.
    /// Creates a dummy game in Firebase.
    public func uploadOneGame() {
        let stub = LevelGrid()
        gsm.saveGame(stub)
            .onSuccess { game in
                self.gsm.uploadGame(uuid: game.uuid!)
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
                self.failure.value = true
        }
    }

    // MARK: - Private methods
    private func subscribeToListType() {
        listType.asObservable().subscribe { type in
            if type.element == .Created {
                self.gsm.getAllGames()
                    .onSuccess { games in
                        self.games.value = games
                    }
                    .onFailure { error in
                        print("\(error.localizedDescription)")
                        self.failure.value = true
                }
            } else {
                self.gsm.loadAllPreviews()
                    .onSuccess { games in
                        self.games.value = games
                    }
                    .onFailure { error in
                        print("\(error.localizedDescription)")
                        self.failure.value = true
                }
            }
        }
        .addDisposableTo(disposeBag)
    }

}
