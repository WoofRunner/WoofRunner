//
//  LevelMarketplaceListCollectionViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LevelMarketplaceListCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Private variables

    private let reuseIdentifier = "Cell"
    private let disposeBag = DisposeBag()

    /// Game names stubbed
    private let games = Observable.just(["a", "b", "c"])

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCellConfiguration()
    }

    private func setupCellConfiguration() {
        games.bindTo(collectionView.rx
            .items(cellIdentifier: reuseIdentifier,
                   cellType: LevelMarketplaceCardViewCell.self)) { row, game, cell in
                    cell.name = game
        }
        .addDisposableTo(disposeBag)
    }

}
