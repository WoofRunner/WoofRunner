//
//  GameplayOverlayDelegate.swift
//  WoofRunner
//
//  Created by See Loo Jane on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

protocol GameplayOverlayDelegate {
	func resumeGame()
	func pauseGame()
	func retryGame()
	func exitGame()
}
