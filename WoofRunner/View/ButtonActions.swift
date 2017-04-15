//
//  ButtonActions.swift
//  WoofRunner
//
//  Created by See Loo Jane on 20/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SpriteKit

/**
Static methods for the generic button press animations used for LDOverlayButtons
*/
struct ButtonActions {
	
	static let buttonScaleFactor = CGFloat(1.2) // How much to increase the size of the button by
	static let buttonAnimationDuration = 0.05 // How fast each action should take
	
	/**
	Returns a SKAction that is to be performed when a button is pressed.
	
	- returns:
	A SKAction that scales up the size of the SKNode
	*/
	static func getButtonPressAction() -> SKAction {
		let action = SKAction.scale(to: ButtonActions.buttonScaleFactor, duration: ButtonActions.buttonAnimationDuration)
		action.timingMode = SKActionTimingMode.easeOut
        
		return action
	}
	
	/**
	Returns a SKAction that is to be performed when a button is released.
	
	- returns:
	A SKAction that scales the the SKNode back to its original size.
	*/
	static func getButtonReleaseAction() -> SKAction {
		let action = SKAction.scale(to: 1.0, duration: ButtonActions.buttonAnimationDuration)
		action.timingMode = SKActionTimingMode.easeOut
		return action
	}
	
	
}
