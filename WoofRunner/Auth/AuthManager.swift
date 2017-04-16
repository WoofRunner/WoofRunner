//
//  AuthManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/10/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit // Because Facebook auth requires a UIViewController
import GoogleSignIn
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

    /// Google profile object that gets set if user is logged in.
    public var googleProfile: GoogleProfile?

    /// Computed variable that returns login status
    public var loggedIn: Bool {
        return facebookToken != nil || googleProfile != nil
    }

    /// Computed variable that represents the preferred login method
    public var preferredLogin: String {
        if let loginMethod = UserDefaults.standard.value(forKey: "login-provider") as? String {
            return loginMethod
        } else {
            return ""
        }
    }

    /// Delegate used here to accomodate for Google login
    public var delegate: AuthManagerDelegate?

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
        if let provider = UserDefaults.standard.value(forKey: "login-provider") as? String {
            guard provider == "facebook" else {
                fatalError("User should not be shown Facebook login if they already authenticated with Google")
            }
        } else {
            UserDefaults.standard.setValue("facebook", forKey: "login-provider")
        }

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
                    } else {
                        if let authUser = user {
                            complete(.success(authUser.uid))
                        } else {
                            complete(.failure(AuthManagerError.FirebaseAuthError))
                        }
                    }
                }
            }
        }
    }

    /// Authenticates using Google profile.
    /// - Parameters:
    ///     - googleProfile: Google profile information
    ///     - accessToken: access token of the authenticated Google user
    public func authWithGoogle(googleProfile: GoogleProfile, accessToken: String) {
        if let provider = UserDefaults.standard.value(forKey: "login-provider") as? String {
            guard provider == "google" else {
                fatalError("User should not be shown Google login if they already authenticated with Google")
            }
        } else {
            UserDefaults.standard.setValue("google", forKey: "login-provider")
        }

        let credential = FIRGoogleAuthProvider.credential(withIDToken: googleProfile.idToken!,
                                                          accessToken: accessToken)

        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                self.delegate?.onGoogleLoginError()
            } else {
                self.setGoogleProfile(googleProfile)
                self.delegate?.onGoogleLoginComplete()
            }
        }
    }

    /// Returns the owner of the game's name.
    public func getName() -> Future<String, AuthManagerError> {
        return Future { complete in
            if let _ = facebookToken {
                let req = FBProfileRequest()
                req.start { (_, result: GraphRequestResult<FBProfileRequest>) in
                    switch result {
                    case .success(let response):
                        guard let name = response.dictionaryValue?["name"] as? String else {
                            fatalError("Name not found")
                        }
                        complete(.success(name))
                    case .failed(let error):
                        print("\(error.localizedDescription)")
                        complete(.failure(AuthManagerError.ProfileError))
                    }
                }
            } else if let google = googleProfile {
                guard let fullName = google.fullName else {
                    fatalError("Current Google user does not have full name")
                }

                complete(.success(fullName))
            } else {
                print("User is not logged in")
                complete(.failure(AuthManagerError.ProfileError))
            }
        }
    }

    /// Sets the Google profile for current user.
    /// - Parameters:
    ///     - profile: GoogleProfile to set for current user
    public func setGoogleProfile(_ profile: GoogleProfile) {
        self.googleProfile = profile
    }

    /**
     Private struct for making a Facebook graph request for user Profile
     */
    private struct FBProfileRequest: GraphRequestProtocol {
        typealias Response = GraphResponse

        public var graphPath = "/me"
        public var parameters: [String : Any]? = ["fields": "id, name"]
        public var accessToken = AccessToken.current
        public var httpMethod: GraphRequestHTTPMethod = .GET
        public var apiVersion: GraphAPIVersion = 2.7

    }

}

public protocol AuthManagerDelegate {
    func onGoogleLoginComplete()
    func onGoogleLoginError()
}

public enum AuthManagerError: Error {
    case FacebookAuthError
    case FirebaseAuthError
    case ProfileError
}
