//
//  LMLoginViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/24/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
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
    private let osm = OnlineStorageManager.getInstance()

    // MARK: - IBOutlets

    // Text above Facebook Login Button
    @IBOutlet var loginPrompt: UILabel!

    // MARK: - IBActions

    /// Handles user tap on Facebook Login Button
    @IBAction func onFbLogin(_ sender: UIButton) {
        if let accessToken = AccessToken.current {
            self.authWithFirebase(token: accessToken.userId!)
            performSegue(withIdentifier: "segueToMarketplace", sender: nil)
            return
        }

        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed:
                self.loginFailed()
            case .cancelled:
                self.loginCancelled()
            case .success( _, _, let accessToken):
                // Removes the button from view
                sender.removeFromSuperview()

                self.loginSuccess(fbuid: accessToken.userId!)
                self.authWithFirebase(token: accessToken.userId!)
                self.performSegue(withIdentifier: "segueToMarketplace", sender: nil)
            }
        }
    }

    // MARK: - Private methods

    /// Handles on Facebook login success
    private func loginSuccess(fbuid: String) {
        loginPrompt.text = "Logged in as \(fbuid)"
    }

    /// Handles on Facebook login cancelled
    private func loginCancelled() {
        loginPrompt.text = MESSAGE_FB_LOGIN_CANCELLED
    }

    /// Handles on Facebook login failed
    private func loginFailed() {
        loginPrompt.text = MESSAGE_FB_LOGIN_FAILED
    }

    /// Authenticates with Firebase
    /// - Parameters:
    ///     - token: Facebook token obtained from authentication
    private func authWithFirebase(token: String) {
        osm.auth(token: token)
    }

}
