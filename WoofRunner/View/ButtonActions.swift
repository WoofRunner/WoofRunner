//
//  ButtonActions.swift
//  WoofRunner
//
//  Created by See Loo Jane on 20/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SpriteKit

struct ButtonActions {
	
	static let buttonScaleFactor = CGFloat(1.2)
	static let buttonAnimationDuration = 0.05
	
	static func getButtonPressAction() -> SKAction {
		let action = SKAction.scale(to: ButtonActions.buttonScaleFactor, duration: ButtonActions.buttonAnimationDuration)
		action.timingMode = SKActionTimingMode.easeOut
        
		return action
	}
	
	static func getButtonReleaseAction() -> SKAction {
		let action = SKAction.scale(to: 1.0, duration: ButtonActions.buttonAnimationDuration)
		action.timingMode = SKActionTimingMode.easeOut
		return action
	}
	
	
}
