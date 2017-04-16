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
import GoogleSignIn
import iCarousel

public class LMHomeViewController: UIViewController {

    // MARK: - Views

    fileprivate var carousel: iCarousel!
    fileprivate var homeButton: UIButton!
    fileprivate var loginOverlay: LoginOverlay?
	fileprivate var loadingOverlay = UIImageView(image: UIImage(named: "loading-bg"))

    // MARK: - Private variables

    fileprivate let gsm = GameStorageManager.shared
    fileprivate var vm = LMHomeViewModel()
    fileprivate let disposeBag = DisposeBag()

    // MARK: - Lifecycle methods

    public override func viewDidLoad() {
        super.viewDidLoad()

        let auth = AuthManager.shared
        if let _ = auth.facebookToken, let _ = auth.firebaseID {
            // User is authenticated.
            setup()
        } else {
            addFacebookLoginOverlay()
        }

        AuthManager.shared.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    // MARK: - Private methods

    /// Adds in a Facebook login overlay if the user is not authenticated yet.
    private func addFacebookLoginOverlay() {
        let loginOverlay = LoginOverlay(frame: view.frame)
        let fbLoginRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(facebookLogin))
        let googleLoginRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(googleLogin)
        )

        loginOverlay.fbButton?.addGestureRecognizer(fbLoginRecognizer)
        loginOverlay.googleButton?.addGestureRecognizer(googleLoginRecognizer)

        if AuthManager.shared.preferredLogin == "facebook" {
            loginOverlay.googleButton?.removeFromSuperview()
        } else if AuthManager.shared.preferredLogin == "google" {
            loginOverlay.fbButton?.removeFromSuperview()
        }

        self.loginOverlay = loginOverlay
        view.addSubview(loginOverlay)
    }

    /// Tap gesture handler for Facebook login overlay button.
    @objc private func facebookLogin(_ sender: UITapGestureRecognizer) {
        let auth = AuthManager.shared
        auth.authWithFacebook(vc: self)
            .flatMap { token in
                return auth.authWithFirebase(facebookToken: token.authenticationToken)
            }
            .onSuccess { _ in
                self.loginOverlay?.removeFromSuperview()
                self.setup()
            }
            .onFailure { error in print("\(error.localizedDescription)") }
    }

    /// Tap gesture handler for Google login overlay button.
    @objc private func googleLogin(_ sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
    }

    /// Loads data, setup views and games.
    fileprivate func setup() {
        loadLevels()
        setupView()
        setupGames()
    }

    /// Setup all the views in marketplace.
    private func setupView() {
        setupBackgroundView()
        setupCarouselView()
        setupHomeButton()
		setupLoadingOverlay()
    }
	
	// Setup the loading overlay view
	private func setupLoadingOverlay() {
		loadingOverlay.image = UIImage(named: "loading-bg")
		self.view.addSubview(loadingOverlay)
		loadingOverlay.frame.size = CGSize(width: 350, height: 350)
		loadingOverlay.frame.origin.x = (view.frame.size.width / 2) - (loadingOverlay.frame.size.width / 2)
		loadingOverlay.frame.origin.y = (view.frame.size.height / 2) - (loadingOverlay.frame.size.height / 2)
		loadingOverlay.isHidden = false
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
        performSegue(withIdentifier: "unwindToMenu", sender: nil)
    }

    /// Loads levels from GameStorageManager into the ViewModel.
    private func loadLevels() {
		self.loadingOverlay.isHidden = false
        gsm.loadAllPreviews()
            .onSuccess { games in
                self.vm.setGames(games)
				self.loadingOverlay.isHidden = true
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
                self.vm.setFailure(true)
				self.loadingOverlay.isHidden = true
        }
    }

    /// Downloads the level to stored
    fileprivate func downloadLevel(uuid: String) {
		self.loadingOverlay.isHidden = false
        gsm.downloadGame(uuid: uuid)
            .onSuccess { game in
                print("Download \(uuid) success")
				self.loadingOverlay.isHidden = true
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
				self.loadingOverlay.isHidden = true
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

// MARK: - GIDSignInDelegate

extension LMHomeViewController: GIDSignInDelegate {

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("\(error.localizedDescription)")
            return
        }

        guard let authentication = user.authentication else {
            return
        }

        let profile = GoogleProfile(
            userId: user.userID,
            idToken: user.authentication.idToken,
            fullName: user.profile.name,
            givenName: user.profile.givenName,
            familyName: user.profile.familyName,
            email: user.profile.email
        )

        AuthManager.shared.authWithGoogle(googleProfile: profile,
                                          accessToken: authentication.accessToken)
    }

}

// MARK: - GIDSignInUIDelegate

extension LMHomeViewController: GIDSignInUIDelegate {}

// MARK: - AuthManagerDelegate

extension LMHomeViewController: AuthManagerDelegate {

    public func onGoogleLoginComplete() {
        loginOverlay?.removeFromSuperview()
        setup()
    }

    public func onGoogleLoginError() {
        print("Error!")
    }

}

// MARK: - DownloadGameTapGesture

fileprivate class DownloadGameTapGesture: UITapGestureRecognizer {

    public private(set) var uuid: String?

    public func setUUID(_ uuid: String) {
        self.uuid = uuid
    }

}
