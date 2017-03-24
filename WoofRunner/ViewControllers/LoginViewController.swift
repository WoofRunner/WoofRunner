//
//  LoginViewController.swift
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
public class LoginViewController: UIViewController {

    @IBOutlet var loginPrompt: UILabel!

    public override func viewDidLoad() {
        super.viewDidLoad()

        addFbLoginButton()
        if let accessToken = AccessToken.current {
            loginPrompt.text = accessToken.userId
            authWithFirebase(token: accessToken.authenticationToken)
        }
    }

    /// Adds a Facebook login button to the view
    private func addFbLoginButton() {
        let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
        loginButton.center = view.center

        view.addSubview(loginButton)
    }

    /// Authenticates with Firebase
    private func authWithFirebase(token: String) {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: token)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
        }
    }

}
