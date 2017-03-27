//
//  LMLoginViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/24/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import FacebookCore
import FacebookLogin

public class LMLoginViewModel {

    public var facebookAuthed = Variable<Bool>(false)
    public var firebaseAuthed = Variable<Bool>(false)
    public var isAuthed: Observable<Bool> {
        return Observable.combineLatest(facebookAuthed.asObservable(), firebaseAuthed.asObservable()) { (facebook, firebase) in
            return facebook && firebase
        }
    }

    private let osm = OnlineStorageManager.getInstance()

    /// Authenticates with Facebook
    public func authWithFacebook(viewController vc: UIViewController) {
        if let accessToken = AccessToken.current {
            self.authWithFirebase(token: accessToken.userId!)
            firebaseAuthed.value = true
        }

        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: vc) { loginResult in
            switch loginResult {
            case .failed:
                print("Log in failed")
            case .cancelled:
                print("Log in cancelld")
            case .success( _, _, let accessToken):
                self.authWithFirebase(token: accessToken.authenticationToken)
                self.firebaseAuthed.value = true
                self.facebookAuthed.value = true
            }
        }
    }

    /// Authenticates with Firebase
    /// - Parameters:
    ///     - token: Facebook token obtained from authentication
    private func authWithFirebase(token: String) {
        osm.auth(token: token)
        firebaseAuthed.value = true
    }

}

/**
 View controller for Facebook Login view to access the Online Level Marketplace.
 */
public class LMLoginViewController: UIViewController {

    // MARK: - Private constants
    private let MESSAGE_FB_LOGIN_CANCELLED = "Login cancelled"
    private let MESSAGE_FB_LOGIN_FAILED = "Login failed"

    // MARK: - Private variables
    private let vm = LMLoginViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - IBOutlets

    // Text above Facebook Login Button
    @IBOutlet var loginPrompt: UILabel!

    // MARK: - IBActions

    /// Handles user tap on Facebook Login Button
    @IBAction func onFbLogin(_ sender: UIButton) {
        vm.authWithFacebook(viewController: self)
    }

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        vm.isAuthed
            .subscribe(onNext: { authed in
                if authed {
                    self.performSegue(withIdentifier: "segueToMarketplace", sender: nil)
                }
            })
            .addDisposableTo(disposeBag)

        vm.isAuthed
            .map { $0 ? "Logged in" : "Please log in" }
            .bindTo(loginPrompt.rx.text)
            .addDisposableTo(disposeBag)
    }

}
