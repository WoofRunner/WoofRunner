//
//  BottomMenuButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 27/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class BottomMenuButton: SKLabelNode {
	
	var delegate: BottomMenuButtonDelegate?
	
	public func setDelegate(_ delegate: BottomMenuButtonDelegate) {
		self.delegate = delegate
	}
	
	public func onTap() {
		if self.text == "Save" {
			self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
				self.delegate?.saveLevel()
			})
			return
		}
		
		if self.text == "Test" {
			
			self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
				self.delegate?.testLevel()
			})
			return
		}
	}
	
}
