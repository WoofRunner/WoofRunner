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
import iCarousel

public class LMHomeViewController: UIViewController {

    // MARK: - Views

    fileprivate var carousel: iCarousel?

    // MARK: - Private variables

    fileprivate let gsm = GameStorageManager.getInstance()
    fileprivate var vm = LMHomeViewModel()
    fileprivate let disposeBag = DisposeBag()

    // MARK: - Lifecycle methods

    public override func viewDidLoad() {
        super.viewDidLoad()
        loadLevels()
        setupView()
        setupGames()
    }

    // MARK: - Private methods

    /// Setup the iCarousel view.
    private func setupView() {
        carousel = iCarousel(frame: self.view.frame)
        carousel?.delegate = self
        carousel?.dataSource = self

        // Carousel specific settings
        carousel?.type = .linear
        carousel?.stopAtItemBoundary = true
        carousel?.scrollToItemBoundary = true
        carousel?.bounces = false
        carousel?.decelerationRate = 0.7

        // Force unwrap as we just set the value of carousel above
        view.addSubview(carousel!)
    }

    /// Loads levels from GameStorageManager into the ViewModel.
    private func loadLevels() {
        gsm.loadAllPreviews()
            .onSuccess { games in
                self.vm.setGames(games)
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
                self.vm.setFailure(true)
            }
    }

    /// Links the ViewModel to the carousel view.
    private func setupGames() {
        vm.games.asObservable().subscribe(onNext: { _ in
            self.carousel?.reloadData()
        })
        .addDisposableTo(disposeBag)
    }

}


// MARK: - iCarouselDataSource

extension LMHomeViewController: iCarouselDataSource {

    public func numberOfItems(in carousel: iCarousel) -> Int {
        return vm.games.value.count
    }

    public func carousel(_ carousel: iCarousel,
                         viewForItemAt index: Int,
                         reusing view: UIView?) -> UIView {
        let levelCardVm = vm.viewModelForGame(at: index)
        let levelCardView = LevelCardView(frame: self.view.frame)
        levelCardView.setupView(vm: levelCardVm)

        return levelCardView
    }

}

// MARK: - iCarouselDelegate

extension LMHomeViewController: iCarouselDelegate {

    public func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        print("Carousel item \(index) selected")
    }

}
