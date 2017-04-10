//
//  AuthManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/10/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit // Because Facebook auth requires a UIViewController
import FirebaseAuth
import FacebookLogin
import FacebookCore
import BrightFutures

/**
 Singleton that handles all authentication operations in the application.
 */
public class AuthManager {

    /// MARK: - Public static variables

    public static var shared: AuthManager = AuthManager()

    /// MARK: - Public variables

    /// Computed variable that returns the current user's Facebook login token.
    public var facebookToken: AccessToken? {
        return AccessToken.current
    }

    /// Computed variable that returns the current user's Firebase user ID.
    public var firebaseID: String? {
        return FIRAuth.auth()?.currentUser?.uid
    }

    /// MARK: - Initialisers

    /// Private init method to make class singleton.
    private init() {}

    /// MARK: - Public methods

    /// Authenticates with Facebook.
    /// - Parameters:
    ///     - vc: ViewController that authentication is done in, required for FacebookAuth
    /// - Returns: Future that contains AccessToken if successful authentication, AuthManagerError
    ///     otherwise
    public func authWithFacebook(vc: UIViewController) -> Future<AccessToken, AuthManagerError> {
        let loginManager = LoginManager()

        return Future { complete in
            DispatchQueue.main.async {
                loginManager.logIn([.publicProfile], viewController: vc) { loginResult in
                    switch loginResult {
                    case .failed:
                        complete(.failure(AuthManagerError.FacebookAuthError))
                    case .cancelled:
                        complete(.failure(AuthManagerError.FacebookAuthError))
                    case .success( _, _, let accessToken):
                        complete(.success(accessToken))
                    }
                }
            }
        }
    }

    /// Authenticates with Firebase.
    /// - Parameters:
    ///     - facebookToken: string that is a Facebook token of a user to authenticate. Firebase
    ///         uses this for authentication
    /// - Returns: Future that contains the user ID as a string if successful, AuthManagerError
    ///     otherwise
    public func authWithFirebase(facebookToken: String) -> Future<String, AuthManagerError> {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: facebookToken)

        return Future { complete in
            DispatchQueue.main.async {
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if let error = error {
                        print("\(error.localizedDescription)")
                        complete(.failure(AuthManagerError.FirebaseAuthError))
                    }

                    if let authUser = user {
                        complete(.success(authUser.uid))
                    }

                    complete(.failure(AuthManagerError.FirebaseAuthError))
                }
            }
        }
    }

}

public enum AuthManagerError: Error {
    case FacebookAuthError
    case FirebaseAuthError
}
