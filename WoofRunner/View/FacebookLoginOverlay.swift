//
//  FacebookLoginOverlay.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/9/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SnapKit

/**
 Shown when Facebook login is required.
 */
public class FacebookLoginOverlay: UIView {

    // MARK: - Private static variables

    private static let BUTTON_TEXT = "LOGIN WITH FACEBOOK"
    private static let BUTTON_HEIGHT = 100
    private static let BUTTON_WIDTH = 350

    // MARK: - Public variables

    public var button: UIButton?
    public var backgroundView: UIView?

    // MARK: - Initialisers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.dimBackground()
        self.setupButton()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder is not supported")
    }

    // MARK: - Private methods

    private func setupButton() {
        let button = UIButton()
        button.setTitle(FacebookLoginOverlay.BUTTON_TEXT, for: .normal)
        button.backgroundColor = UIColor.blue
        button.alpha = 1.0

        self.button = button
        addSubview(button)

        // Set contraints
        button.snp.makeConstraints { make in
            make.height.equalTo(FacebookLoginOverlay.BUTTON_HEIGHT)
            make.width.equalTo(FacebookLoginOverlay.BUTTON_WIDTH)
            make.center.equalTo(self)
        }
    }

    private func dimBackground() {
        let background = UIView(frame: frame)
        background.backgroundColor = UIColor.black
        background.alpha = 0.5

        self.backgroundView = background
        addSubview(background)
        sendSubview(toBack: background)
    }

}
