//
//  GameplayOverlayConstants.swift
//  WoofRunner
//
//  Created by See Loo Jane on 15/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

/**
Contains the constant values that configures the GameplayOverlayScene
*/
struct GameplayOverlayConstants {
	
	// Menu Backgrounds
	static let pauseMenuBG = "pause-menu-bg"
	static let winMenuBG = "win-menu-bg"
	static let loseMenuBG = "lose-menu-bg"
	
	// Score Label
	static let scoreLabelFont = "AvenirNext-Bold"
	static let scoreLabelXPosScale = CGFloat(0.9)
	static let scoreLabelYPosScale = CGFloat(0.9)
	static let scoreLabelFontSize = CGFloat(48)
	
	// Menu Button
	static let menuButtonSprite = SKTexture(imageNamed: "pause-button")
	static let menuButtonSize = CGSize(width: 60.0, height: 60.0)
	static let menuButtonXPosScale = CGFloat(0.1)
	static let menuButtonYPosScale = CGFloat(0.9)
 
	// Menu Overlay
	static let overlayXPosScale = CGFloat(0.5)
	static let overlayYPosScale = CGFloat(0.5)
	static let overlayColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
	
	// Pause Menu
	static let pauseMenuSize = CGSize(width: 500, height: 500)
	static let pResumeButtonPos = CGPoint(x: 0,
	                                     y: pauseMenuSize.height / 3 - 60)
	static let pRetryButtonPos = CGPoint(x: 0,
	                                    y: pauseMenuSize.height / 3 - 160)
	static let pExitButtonPos = CGPoint(x: 0,
	                                   y: pauseMenuSize.height / 3 - 260)
	
	// Win/Lose Menu
	static let endMenuSize = CGSize(width: 500, height: 500)
	static let endMenuScoreLabelFontSize = CGFloat(40)
	static let eRetryButtonPos = CGPoint(x: 0,
	                                     y: endMenuSize.height / 3 - 130)
	static let eExitButtonPos = CGPoint(x: 0,
	                                    y: endMenuSize.height / 3 - 210)
		
	
}

