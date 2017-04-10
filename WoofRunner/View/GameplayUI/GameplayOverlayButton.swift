//
//  GameplayOverlayButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class GameplayOverlayButton: SKSpriteNode {
	
	private var type: GameplayOverlayButtonType = .resume
	private var delegate: GameplayOverlayButtonDelegate?
	
	override init(texture: SKTexture!, color: SKColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	convenience init(type: GameplayOverlayButtonType) {
		let imageNamed = type.getSpritePath()
		self.init(texture: SKTexture(imageNamed: imageNamed))
		self.type = type
	}
	
	public func setDelegate(_ delegate: GameplayOverlayButtonDelegate) {
		self.delegate = delegate
	}
	
	// Logic for tap
	public func onTap() {
		guard let delegate = delegate else {
			print("Please assign a GameplayOverlayButtonDelegate first!")
			return
		}
		
		self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
			delegate.handleButtonTap(self.type)
		})
		
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}
