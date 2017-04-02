//
//  LMLoginViewModel.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/27/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

// For Facebook auth since it needs to pass in a ViewController
// It is generally bad practice to import UIKit in ViewModels!
import UIKit

import RxSwift
import RxCocoa
import FirebaseAuth
import FacebookCore
import FacebookLogin

public class LMLoginViewModel {

    public var facebookAuthed = Variable<Bool>(false)
    public var firebaseAuthed = Variable<Bool>(false)
    public var authFailure = Variable<Bool?>(nil)
    public var isAuthed: Observable<Bool> {
        return Observable.combineLatest(
            facebookAuthed.asObservable(), firebaseAuthed.asObservable()
        ) { (facebook, firebase) in
            return facebook && firebase
        }
    }

    private let osm = OnlineStorageManager.getInstance()

    /// Authenticates with Facebook
    public func authWithFacebook(viewController vc: UIViewController) {
        if let accessToken = AccessToken.current {
            self.facebookAuthed.value = true
            self.authWithFirebase(token: accessToken.authenticationToken,
                                  userId: accessToken.userId!)
            return
        }

        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: vc) { loginResult in
            switch loginResult {
            case .failed:
                print("Log in failed")
            case .cancelled:
                print("Log in cancelld")
            case .success( _, _, let accessToken):
                self.facebookAuthed.value = true
                self.authWithFirebase(token: accessToken.authenticationToken,
                                      userId: accessToken.userId!)
            }
        }
    }

    /// Authenticates with Firebase
    /// - Parameters:
    ///     - token: Facebook token obtained from authentication
    private func authWithFirebase(token: String, userId: String) {
        osm.auth(token: token, userId: userId)
            .onSuccess { _ in self.firebaseAuthed.value = true }
            .onFailure { _ in self.authFailure.value = true }
    }

}
