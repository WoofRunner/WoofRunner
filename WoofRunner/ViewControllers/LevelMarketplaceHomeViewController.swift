//
//  LevelMarketplaceHomeViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public class LevelMarketplaceHomeViewController: UIViewController {

    // MARK: - Private variables

    private var games = Variable<[String]>([])

    // MARK: - IBActions

    @IBAction func navigateToDownloadedGames(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLevelList", sender: LevelListType.Downloaded)
    }

    @IBAction func navigateToCreatedGames(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLevelList", sender: LevelListType.Created)
    }

    @IBAction func unwindToLevelMarketplaceHome(segue: UIStoryboardSegue) {}

    // MARK: - Lifecycle methods

    public override func viewDidLoad() {
        super.viewDidLoad()

        loadGames()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LevelMarketplaceListViewController {
            let levelListType = sender as! LevelListType
            destination.listType = levelListType
        }

        // Embedded segues
        if let destination = segue.destination as? LevelMarketplaceListCollectionViewController {
            destination.games = games
        }
    }

    /// Loads all games that user have yet to download
    private func loadGames() {
        games.value = ["12", "34", "56"]
    }

}
