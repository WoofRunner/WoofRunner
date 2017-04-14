//
//  GameplayOverlayButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

/**
SKSpriteNode that represents a button used in GameplayOverlay UI.
*/
class GameplayOverlayButton: SKSpriteNode {
	
	// MARK: - Private Variables
	
	private var type: GameplayOverlayButtonType = .resume
	private var delegate: GameplayOverlayButtonDelegate?
	
	// MARK: Initialisers
	
	override init(texture: SKTexture!, color: SKColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	convenience init(type: GameplayOverlayButtonType) {
		let imageNamed = type.getSpritePath()
		self.init(texture: SKTexture(imageNamed: imageNamed))
		self.type = type
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
	// MARK: - Public Methods
	
	public func setDelegate(_ delegate: GameplayOverlayButtonDelegate) {
		self.delegate = delegate
	}
	
	/**
	Performs the tap logic given its own button type. 
	
	- important:
	GameplayOverlayButtonDelegate needs to be assigned first to carry out the logic
	*/
	public func onTap() {
		guard let delegate = delegate else {
			print("Please assign a GameplayOverlayButtonDelegate first!")
			return
		}
		
		self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
			delegate.handleButtonTap(self.type)
		})
		
	}
	
	
	

}
