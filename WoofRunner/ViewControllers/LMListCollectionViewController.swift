//
//  LMListCollectionViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LMListCollectionViewController: UIViewController {
    @IBOutlet weak var levelList: UICollectionView!

    // MARK: - Private variables

    private let reuseIdentifier = "Cell"
    private let disposeBag = DisposeBag()

    /// Game names stubbed
    public var games: Variable<[String]>?

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCellConfiguration()
    }

    private func setupCellConfiguration() {
        games?.asObservable()
            .bindTo(levelList.rx
            .items(cellIdentifier: reuseIdentifier,
                   cellType: LMCardViewCell.self)) { row, game, cell in
                    cell.name = game
        }
        .addDisposableTo(disposeBag)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension LMListCollectionViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - Overriden methods

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateLevelCardSize()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

    // MARK: - Private methods

    /// Get a single level card size
    private func calculateLevelCardSize() -> CGSize {
        let width = (view.frame.width - 40) / 2
        let height: CGFloat = 100.0

        return CGSize(width: width, height: height)
    }

}
