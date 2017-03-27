//
//  LMListViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ObjectMapper
import FirebaseAuth

public enum LevelListType {
    case Downloaded
    case Created
}

public class LMListViewController: UIViewController {

    // MARK: - Public variables

    public var listType: LevelListType?

    // MARK: - Private variables

    private var games = Variable<[StoredGame]>([])
    private var cdm = CoreDataManager.getInstance()
    private var osm = OnlineStorageManager.getInstance()

    // MARK: - IBOutlets

    @IBOutlet var viewTitle: UILabel!

    // MARK: - IBActions

    /// Stubbed action to test out RxSwift
    @IBAction func addGame(_ sender: UIButton) {
        if listType == .Downloaded {
            uploadOneGame()
        } else {
            addOneStubCreatedGame()
        }
    }

    // MARK: - Lifecyle methods

    public override func viewDidLoad() {
        switch listType! {
        case .Downloaded:
            viewTitle.text = "Downloaded Levels"
        case .Created:
            viewTitle.text = "Created Levels"
        }

        loadGames()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // For embeded segue
        if let destination = segue.destination as? LMListCollectionViewController {
            destination.games = games
        }
    }

    // MARK: - Private methods

    /// Load all games depending on the list type
    private func loadGames() {
        if listType == .Downloaded {
            loadDownloadedGames()
        } else if listType == .Created {
            loadCreatedGames()
        }
    }

    /// Loads all downloaded games
    private func loadDownloadedGames() {}

    /// Loads all created games
    private func loadCreatedGames() {}

    // Saves a new game to CoreData
    private func addOneStubCreatedGame() {}

    private func uploadOneGame() {}
}
