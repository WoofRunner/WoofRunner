//
//  GameplayOverlayButtonDelegate.swift
//  WoofRunner
//
//  Created by See Loo Jane on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

/**
To allow the GameplayOverlayButton nodes to access callbacks in the parent
class that created them.
*/
protocol GameplayOverlayButtonDelegate {
	
	/**
	Performs the tap logic when button is tapepd
	*/
	func handleButtonTap(_ type: GameplayOverlayButtonType)
}
