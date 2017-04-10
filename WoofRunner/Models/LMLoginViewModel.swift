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

    /// Authenticates with Facebook
    public func authWithFacebook(viewController vc: UIViewController) {
        let auth = AuthManager.shared
        if let _ = auth.firebaseID, let _ = auth.facebookToken {
            // User is already authenticated if both token exists.
            return
        }

        if let facebookToken = auth.facebookToken {
            self.facebookAuthed.value = true
            auth.authWithFirebase(facebookToken: facebookToken.authenticationToken)
                .onSuccess { _ in self.firebaseAuthed.value = true }
                .onFailure { _ in self.authFailure.value = true }
        } else {
            auth.authWithFacebook(vc: vc)
                .map { token in auth.authWithFirebase(facebookToken: token.authenticationToken) }
                .onSuccess { _ in self.firebaseAuthed.value = true }
                .onFailure { _ in self.authFailure.value = true }
        }
    }

}
