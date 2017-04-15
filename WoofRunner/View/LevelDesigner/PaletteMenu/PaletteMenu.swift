//
//  PaletteMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//	

import SpriteKit

/**
PaletteMenu is a subclass of SKNode that contains children PaletteButton nodes. 
Its position is set implicitly within the initialiser.
*/
class PaletteMenu: SKNode {
	
	typealias Palette = LDOverlaySceneConstants.PaletteConstants
	
	// MARK: - Private Variables
	
	private var backgroundNode = SKNode()
	private var buttonArray = [PaletteButton]() // Required to easily set PaletteButtonDelegate for the buttons
	
	// MARK: - Initialiser
	
	override init() {
		super.init()
		self.position = Palette.palettePosition
		initPaletteBackground()
		initPaletteButtons()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Public Methods
	
	private func initPaletteBackground() {
		backgroundNode = CustomShapeNodes
						.getRoundedRectangleNode(height: Palette.paletteHeight,
						                         width: Palette.paletteWidth,
		                                         radius: Palette.backgroundCornerRadius,
		                                         backgroundColor: Palette.backgroundColor)
		// Attach background first
		self.addChild(backgroundNode)
	}
	
	
	private func initPaletteButtons() {
		
		// Base x and y positions for the palette buttons
		var buttonY = Palette.paletteButtonY0
		let buttonX = Palette.paletteButtonX0
		
		// Create and attach the palette button nodes
		for type in Palette.buttonTypesArray {
			
			// Create
			let buttonNode = PaletteButton(funcType: type, size: Palette.paletteButtonSize)
			
			// Set position according to offsets
			buttonNode.position = CGPoint(x: buttonX, y: buttonY)
			buttonY -= Palette.paletteButtonWidth + Palette.paletteButtonMargin
			
			// Add node
			self.addChild(buttonNode)
			self.buttonArray.append(buttonNode)
		}
	}
	
	/**
	Assigns the PaletteButtonDelegate for all the PaletteButtons found in the PaletteMenu
	*/
	public func assignDelegateForButtons(_ delegate: PaletteButtonDelegate) {
		for button in buttonArray {
			button.setDelegate(delegate)
		}
	}
	
}




