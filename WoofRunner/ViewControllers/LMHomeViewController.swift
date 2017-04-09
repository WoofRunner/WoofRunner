//
//  LMHomeViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import iCarousel

public class LMHomeViewController: UIViewController {

    // MARK: - Views

    fileprivate var carousel: iCarousel!
    fileprivate var homeButton: UIButton!

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

    /// Setup all the views in marketplace.
    private func setupView() {
        setupBackgroundView()
        setupHomeButton()
        setupCarouselView()
    }

    /// Setup the iCarousel view.
    private func setupCarouselView() {
        // Setup carousel
        carousel = iCarousel(frame: self.view.frame)
        carousel.delegate = self
        carousel.dataSource = self

        // Carousel specific settings
        carousel.type = .linear
        carousel.stopAtItemBoundary = true
        carousel.scrollToItemBoundary = true
        carousel.bounces = false
        carousel.decelerationRate = 0.7

        view.addSubview(carousel)
    }

    /// Setup the background image view of marketplace.
    private func setupBackgroundView() {
        let backgroundView = UIImageView(image: UIImage(named: "menu-background"))
        backgroundView.frame = view.frame
        view.addSubview(backgroundView)
        view.sendSubview(toBack: backgroundView)
    }

    /// Setup the home button view of marketplace.
    private func setupHomeButton() {
        let homeButton = UIButton()
        homeButton.setBackgroundImage(UIImage(named: "home-button"), for: .normal)
        view.addSubview(homeButton)

        homeButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.equalTo(self.view).offset(20)
            make.left.equalTo(self.view).offset(20)
        }

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        homeButton.addGestureRecognizer(recognizer)
    }

    /// Tap gesture action for home button.
    func dismissView(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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

    /// Downloads the level to stored
    fileprivate func downloadLevel(uuid: String) {
        gsm.downloadGame(uuid: uuid)
            .onSuccess { game in
                print("Download \(uuid) success")
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
        }
    }

    /// Links the ViewModel to the carousel view.
    private func setupGames() {
        vm.games.asObservable().subscribe(onNext: { _ in
            self.carousel?.reloadData()
        })
        .addDisposableTo(disposeBag)
    }

    /// Download button tap gesture recognizer
    public func downloadButtonTap(_ sender: DownloadGameTapGesture) {
        guard let uuid = sender.uuid else {
            fatalError("Game does not have UUID attached")
        }

        downloadLevel(uuid: uuid)
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

        // Create a new view model
        let levelCardVm = vm.viewModelForGame(at: index)

        // Initialize new card view
        let marketplaceCardView = MarketplaceLevelCard(frame: self.view.frame)
        marketplaceCardView.isUserInteractionEnabled = true
        marketplaceCardView.setupView(vm: levelCardVm)

        // Add tap gesture recognizer
        let recognizer = DownloadGameTapGesture(target: self, action: #selector(downloadButtonTap))
        recognizer.setUUID(levelCardVm.levelUUID)
        marketplaceCardView.downloadButton.addGestureRecognizer(recognizer)

        return marketplaceCardView
    }

}

// MARK: - iCarouselDelegate

extension LMHomeViewController: iCarouselDelegate {

    public func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        // TODO: Do something when a carousel is tapped at other places except the download button.
        // Can show game details, difficulty etc.
        print("Carousel item \(index) selected")
    }

}
