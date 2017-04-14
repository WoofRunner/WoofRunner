//
//  GameplayOverlayDelegate.swift
//  WoofRunner
//
//  Created by See Loo Jane on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

/**
To allow the GameplayOverlayScene to access callbacks in the parent
class that created them.
*/
protocol GameplayOverlayDelegate {
	
	/**
	Performs the logic when user taps on resume game
	*/
	func resumeGame()
	
	/**
	Performs the logic when user taps on pause game
	*/
	func pauseGame()
	
	/**
	Performs the logic when user taps on retry game
	*/
	func retryGame()
	
	/**
	Performs the logic when user taps on exit game
	*/
	func exitGame()
}
