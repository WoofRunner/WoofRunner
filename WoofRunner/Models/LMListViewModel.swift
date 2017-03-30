//
//  LMListViewModel.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/31/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import RxSwift

/**
 View model for LMListView.
 */
public class LMListViewModel {

    // MARK: - Public variables
    public private(set) var listType = Variable<LevelListType>(.Downloaded)
    public private(set) var games = Variable<[StoredGame]>([])

    // MARK: - Private variables

    private let gsm = GameStorageManager.getInstance()

    public init() {
        self.games.value = gsm.getAllGames()
    }

    // MARK: - Public method

    /// Sets the type of games shown in the current level list view.
    /// - Parameters:
    ///     - listType: LevelListType enum that represents the type of list displayed to the user
    public func setListType(_ listType: LevelListType) {
        self.listType.value = listType
    }

    /// FOR TESTING ONLY.
    /// Creates a dummy game in CoreData.
    public func createOneGame() {
        gsm.saveGame(SaveableStub())
    }

    /// FOR TESTING ONLY.
    /// Creates a dummy game in Firebase.
    public func uploadOneGame() {
        guard let game = gsm.getAllGames().first else {
            print("Game does not exist yet")
            return
        }

        print("Uploading \(game.uuid)...")
        gsm.uploadGame(uuid: game.uuid!)
    }

}

private struct SaveableStub: SaveableGame {

    fileprivate func toStoredGame() -> StoredGame {
        let saved = StoredGame()
        saved.uuid = UUID().uuidString
        saved.createdAt = Date() as NSDate?
        saved.updatedAt = Date() as NSDate?

        return saved
    }

    fileprivate func load(from storedGame: StoredGame) {
    }

}
