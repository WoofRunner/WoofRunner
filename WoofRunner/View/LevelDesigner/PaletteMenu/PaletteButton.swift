//
//  PaletteButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//
//	The PaletteButton subclasses SKSpriteNode and conforms
//	to the LDOverlayButton protocol. It requires a PaletteButtonDelegate
//	to perform tap callbacks.

import SpriteKit

class PaletteButton: SKSpriteNode, LDOverlayButton {
	
	
	// MARK: - Private Variables
	
	private var paletteFunctionType: PaletteFunctionType = .platform
	private var paletteButtonDelegate: PaletteButtonDelegate?
	
	
	// MARK: - Initialisers 
	
	override init(texture: SKTexture!, color: SKColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	/**
	Creates a PaletteButton with the input PaletteButtonFunctionType and size
		
	- parameters:
		- funcType: PaletteFunctionType of the button
		- size: CGSize of the button
	*/
	convenience init(funcType: PaletteFunctionType, size: CGSize) {
		let imageName = funcType.getSpriteImageName()
		self.init(texture: SKTexture(imageNamed: imageName), color: SKColor.clear, size: size)
		self.paletteFunctionType = funcType
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Public Methods
	
	
	/**
	Set PaletteButtonDelegate attribute for this button
	*/
	public func setDelegate(_ delegate: PaletteButtonDelegate) {
		self.paletteButtonDelegate = delegate
	}
	
	/**
	Performs the tap logic for this button
		
	- important:
	Requires a PaletteButtonDelegate to be set first.
	
	*/
	public func onTap() {
		guard let delegate = paletteButtonDelegate else {
			print("Please assign a PaletteButtonDelegate first!")
			return
		}
		
		self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
			delegate.handlePaletteTap(self.paletteFunctionType)
		})
		
	}
	
	
	
	
	
	
	
}
