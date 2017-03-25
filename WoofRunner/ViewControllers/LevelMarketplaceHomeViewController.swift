//
//  LevelMarketplaceHomeViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

class LevelMarketplaceHomeViewController: UIViewController {

    // MARK: - IBActions

    @IBAction func navigateToDownloadedGames(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLevelList", sender: LevelListType.Downloaded)
    }

    @IBAction func navigateToCreatedGames(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLevelList", sender: LevelListType.Created)
    }

    // MARK: - Lifecycle methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let levelListType = sender as! LevelListType
        let destination = segue.destination as! LevelMarketplaceListViewController
        destination.listType = levelListType
    }

}
