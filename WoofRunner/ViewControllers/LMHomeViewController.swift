//
//  LMHomeViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public class LMHomeViewController: UIViewController {

    // MARK: - Private variables

    private var vm = LMHomeViewModel()
    private var games = Variable<[SaveableGame]>([])

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
        vm.loadFeaturedGames()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LMListViewController {
            let levelListType = sender as! LevelListType
            destination.listType = levelListType
        }

        // Embedded segues
        if let destination = segue.destination as? LMListCollectionViewController {
            destination.games = vm.featuredGames
        }
    }

}
