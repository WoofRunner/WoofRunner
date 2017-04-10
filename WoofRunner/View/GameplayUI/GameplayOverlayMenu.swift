//
//  GameplayOverlayMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 10/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class GameplayOverlayMenu: SKNode {
	
	private var type: GameplayOverlayMenuType = .pause
	
	override init() {
		super.init()
	}
	
	convenience init(type: GameplayOverlayMenuType, buttonDelegate: GameplayOverlayDelegate) {
		let imageNamed = type.getSpritePath()
		self.init()
		self.type = type
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	
}
