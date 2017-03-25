//
//  LevelMarketplaceListViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public enum LevelListType {
    case Downloaded
    case Created
}

public class LevelMarketplaceListViewController: UIViewController {

    // MARK: - Public variables

    public var listType: LevelListType?

    // MARK: - Private variables

    private var games = Variable<[String]>(["a", "b", "c"])

    // MARK: - IBOutlets

    @IBOutlet var viewTitle: UILabel!

    // MARK: - IBActions

    /// Stubbed action to test out RxSwift
    @IBAction func addGame(_ sender: UIButton) {
        games.value.append("z")
    }

    // MARK: - Lifecyle methods

    public override func viewDidLoad() {
        switch listType! {
        case .Downloaded:
            viewTitle.text = "Downloaded Levels"
        case .Created:
            viewTitle.text = "Created Levels"
        }
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LevelMarketplaceListCollectionViewController {
            destination.games = games
        }
    }

}
