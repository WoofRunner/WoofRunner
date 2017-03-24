//
//  LoginViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/24/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
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
            loginPrompt.text = accessToken.authenticationToken
        }
    }

    /// Adds a Facebook login button to the view
    private func addFbLoginButton() {
        let loginButton = LoginButton(readPermissions: [.publicProfile])
        loginButton.center = view.center

        view.addSubview(loginButton)
    }

}
