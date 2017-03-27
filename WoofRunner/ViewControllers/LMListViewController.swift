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

    private var games = Variable<[SaveableStub]>([])
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
    private func loadDownloadedGames() {
        osm.loadAll().onSuccess { gameDict in
            let games = gameDict!

            // TODO: Parse all NSDictionaries into a proper game object, currently stubbed
            self.games.value = games.map { (uuid, game) in SaveableStub(uuid: uuid as! String) }
        }
    }

    /// Loads all created games
    private func loadCreatedGames() {
        cdm.loadAll().onSuccess { games in
            // TODO: Parse all StoredGame back into the original game format, currently stubbed.
            self.games.value = games.map { SaveableStub(uuid: $0.uuid!) }
        }
    }

    private func addOneStubCreatedGame() {
        // Saves a new game to CoreData
        let stub = SaveableStub(uuid: UUID.init().uuidString)
        cdm.save(stub)
            .onSuccess { _ in
                self.games.value.append(stub)
        }
    }

    private func uploadOneGame() {
        let stub = SaveableStub(uuid: UUID.init().uuidString)
        osm.save(stub)
    }
}

/**
 For testing purposes
 */
public struct SaveableStub: UploadableGame {
    public var ownerID: String?
    public var uuid: String?
    public var obstacles: [SaveableObstacle]?
    public var platforms: [SaveablePlatform]?
    public var createdAt: Date?
    public var updatedAt: Date?

    public init(uuid: String) {
        self.ownerID = (FIRAuth.auth()?.currentUser?.uid)! // User should not be unauthed.
        self.uuid = uuid
        self.obstacles = []
        self.platforms = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    public func toStoredGame() -> StoredGame {
        return StoredGame()
    }
}

extension SaveableStub: Mappable {

    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        ownerID <- map["ownerID"]
        uuid <- map["uuid"]
        obstacles <- map["obstacles"]
        platforms <- map["platforms"]
        createdAt <- (map["createdAt"], DateTransform())
        updatedAt <- (map["updatedAt"], DateTransform())
    }
}
