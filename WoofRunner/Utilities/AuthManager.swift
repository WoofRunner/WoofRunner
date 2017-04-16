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

    /// Google profile object that gets set if user is logged in.
    public var googleProfile: GoogleProfile?

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
        if let provider = UserDefaults.value(forKey: "login-provider") as? String {
            guard provider == "facebook" else {
                fatalError("User should not be shown Facebook login if they already authenticated with Facebook")
            }
        } else {
            UserDefaults.setValue("facebook", forKey: "login-provider")
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

    /// Returns the name of a given Facebook profile ID.
    /// - Parameters:
    ///     - id: Facebook profile ID
    /// - Returns: a Future of the profile name if success, error if failure
    public func getName(ownerId: String) -> Future<String, AuthManagerError> {
        return Future { complete in
            var req = FBProfileRequest()
            req.setProfileId(id: ownerId)
            req.start { (_, result: GraphRequestResult<FBProfileRequest>) in
                switch result {
                case .success(let response):
                    guard let name = response.dictionaryValue?["name"] as? String else {
                        fatalError("Name not found")
                    }
                    complete(.success(name))
                case .failed(let error):
                    print("\(error.localizedDescription)")
                    complete(.failure(AuthManagerError.FacebookAuthError))
                }
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

        public mutating func setProfileId(id: String) {
            self.graphPath = "/\(id)"
        }

    }

}

public enum AuthManagerError: Error {
    case FacebookAuthError
    case FirebaseAuthError
}
