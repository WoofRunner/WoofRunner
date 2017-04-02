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
    public private(set) var listType = Variable<LevelListType>(.Downloaded)
    public private(set) var games = Variable<[StoredGame]>([])
    public private(set) var failure = Variable<Bool>(false)

    // MARK: - Private variables

    private let gsm = GameStorageManager.getInstance()

    public init() {
        loadGames()
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
    private func loadGames() {
        // TODO: Filter based on list type
        if listType.value == .Created {
            gsm.getAllGames()
                .onSuccess { games in
                    self.games.value = games
                }
                .onFailure { error in
                    print("\(error.localizedDescription)")
                    self.failure.value = true
            }
        } else {
            gsm.downloadGame(uuid: "512126AB-6599-454D-8322-6A6361548EF8")
                .onSuccess { game in
                    self.games.value.append(game)
                }
                .onFailure { error in
                    print("\(error.localizedDescription)")
                    self.failure.value = true
            }
        }

    }

}
