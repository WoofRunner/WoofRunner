//
//  LoginViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/24/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import FacebookLogin

/**
 View controller for Facebook Login view to access the Online Level Marketplace.
 */
public class LoginViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        addFbLoginButton()
    }

    private func addFbLoginButton() {
        let loginButton = LoginButton(readPermissions: [.publicProfile])
        loginButton.center = view.center

        view.addSubview(loginButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
