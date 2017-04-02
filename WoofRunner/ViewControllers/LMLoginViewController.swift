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
    }

}
