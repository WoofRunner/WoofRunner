//
//  LoginOverlay.swift
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
public class LoginOverlay: UIView {

    // MARK: - Private static variables

	private static let TITLE_STROKE_COLOR = UIColor(red: 0.78, green: 0.47, blue: 0.20, alpha: 1.0)
	private static let TITLE_FONT_COLOR = UIColor(red: 0.96, green: 0.87, blue: 0.72, alpha: 1.0)
	private static let TITLE_FONT = UIFont(name: "AvenirNext-Bold", size: 40)!
	private static let TITLE_STROKE_SIZE = CGFloat(4.0)
	private static let TITLE_TOP_OFFSET = 30

    // MARK: - Public variables

    public var fbButton: UIButton?
    public var googleButton: UIButton?
    public var backgroundView: UIView?

    // MARK: - Private variables

    private var title: StrokedLabel? // Cannot be declared public as it uses internal types

    // MARK: - Initialisers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.dimBackground()
		self.setupTitle()
        self.setupButton()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder is not supported")
    }

    // MARK: - Private methods
	
	private func setupTitle() {
		let title = StrokedLabel()
		title.text = "Login To Marketplace"
		title.strokedText(strokeColor: LoginOverlay.TITLE_STROKE_COLOR,
		                  fontColor: LoginOverlay.TITLE_FONT_COLOR,
		                  strokeSize: LoginOverlay.TITLE_STROKE_SIZE,
		                  font: LoginOverlay.TITLE_FONT)
		self.title = title
		addSubview(title)
		
		// Set contraints
		title.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview().offset(LoginOverlay.TITLE_TOP_OFFSET)
		}
		
	}

    private func setupButton() {
        let fbButton = UIButton()
		fbButton.setImage(UIImage(named: "fb-login-btn"), for: .normal)

        self.fbButton = fbButton
        addSubview(fbButton)

        let googleButton = UIButton()
        googleButton.setImage(UIImage(named: "fb-login-btn"), for: .normal)

        self.googleButton = googleButton
        addSubview(googleButton)

        // Set contraints
        fbButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }

        googleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
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
