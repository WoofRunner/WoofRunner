//
//  PaletteButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class PaletteButton: RootSKSpriteNode, LDOverlayButton {
	
	private var paletteFunctionType: PaletteFunctionType = .platform
	private var paletteButtonDelegate: PaletteButtonDelegate?
	
	override init(texture: SKTexture!, color: SKColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	convenience init(imageNamed: String, funcType: PaletteFunctionType, size: CGSize) {
		self.init(texture: SKTexture(imageNamed: imageNamed), color: SKColor.clear, size: size)
		self.paletteFunctionType = funcType
	}
	
	public func setDelegate(_ delegate: PaletteButtonDelegate) {
		self.paletteButtonDelegate = delegate
	}
	
	// Logic for tap
	public func onTap() {
		guard let delegate = paletteButtonDelegate else {
			print("Please assign a PaletteButtonDelegate first!")
			return
		}
		
		self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
			delegate.handlePaletteTap(self.paletteFunctionType)
		})
		
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		// Decoding length here would be nice...
		super.init(coder: aDecoder)
	}
	
	
	
	
}