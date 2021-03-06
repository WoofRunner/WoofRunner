//
//  BottomMenuSpriteButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 27/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//
//	The BottomMenuSpriteButton subclasses SKSpriteNode and conforms
//	to the LDOverlayButton protocol. It requires a BottomMenuDelegate
//	to perform tap callbacks.

import SpriteKit

/**
Subclasses SKSpriteNode and conforms to the LDOverlayButton protocol. 
It requires a BottomMenuDelegate to perform tap callbacks.
*/
class BottomMenuSpriteButton: SKSpriteNode, LDOverlayButton {
	
	// MARK: - Private Variables
	
	private var type: BottomMenuButtonType = .save
	private var delegate: BottomMenuButtonDelegate?
	
	
	// MARK: - Initialisers
	
	override init(texture: SKTexture!, color: SKColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	/**
	Initialises a BottomMenuSpriteButton of the given BottomMenuButtonType and the given CGSize.
	*/
	convenience init(type: BottomMenuButtonType, size: CGSize) {
		self.init(texture: SKTexture(imageNamed: type.getImageSprite()), color: SKColor.clear, size: size)
		self.type = type
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Public Functions
	
	/**
	Sets the BottomeMenuButtonDelegate attribute for this button
	*/
	public func setDelegate(_ delegate: BottomMenuButtonDelegate) {
		self.delegate = delegate
	}
	
	// MARK: - LDOverlayButton
	
	internal func onTap() {
		if self.type == .save {
			self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
				self.delegate?.saveLevel()
			})
			return
		}
		
		if self.type == .back {
			self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
				self.delegate?.back()
			})
			return
		}
	}
	
}
