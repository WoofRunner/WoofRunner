//
//  OverlayButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

/**
A SKSpriteNode that implements the LDOverlayButton protocol and represents a possible
type of tile selection inside the OverlayMenu
*/
class OverlayButton: SKSpriteNode, LDOverlayButton {
	
	// MARK: - Private Variables
	
	private var tileName: String? = ""
	private var overlayButtonDelegate: OverlayButtonDelegate?
	
	// MARK: - Initialisers
	
	override init(texture: SKTexture!, color: SKColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	convenience init(imageNamed: String, tileName: String?, size: CGSize) {
		self.init(texture: SKTexture(imageNamed: imageNamed), color: SKColor.clear, size: size)
		self.tileName = tileName
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Public Methods
	
	/**
	Sets the OverlayButtonDelegate this button
	*/
	public func setDelegate(_ delegate: OverlayButtonDelegate) {
		self.overlayButtonDelegate = delegate
	}
	
	
	// MARK: - LDOverlayButton
	
	/**
	Performs the tap logic for this button
	
	- important:
	Requires a OverlayButtonDelegate to be set first.
	
	*/
	public func onTap() {
		guard let delegate = overlayButtonDelegate else {
			print("Please assign a OverlayButtonDelegate first!")
			return
		}
		
		self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
			delegate.setCurrentTileSelection(self.tileName)
			delegate.closeOverlayMenu()
		})
	}
	
	
}
