//
//  PaletteMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class PaletteMenu: SKNode {
	
	typealias Palette = LDOverlaySceneConstants.PaletteConstants
	
	private let backgroundNode = CustomShapeNodes.getRoundedRectangleNode(height: Palette.paletteHeight,
		                                                             width: Palette.paletteWidth,
		                                                             radius: 25,
		                                                             backgroundColor: Palette.paletteBackgroundColor)
	private var buttonArray = [PaletteButton]()
	
	override init() {
		super.init()
	}
	
	/* Convenience init might be used if palette button types cannot be predetermined
	convenience init(buttonTypesArray: [PaletteFunctionType]) {
		self.init()
		self.buttonTypesArray = buttonTypesArray
		renderPaletteMenu()
	}
	*/
	
	// Renders the palette menu at the input position (which is the bottom-left corner
	// of the menu's frame)
	public func renderPaletteMenu() {
		
		self.position = Palette.palettePosition
		
		// Base x and y positions for the palette buttons
		var buttonY = Palette.paletteButtonY0
		let buttonX = Palette.paletteButtonX0
		
		// Attach background first
		self.addChild(backgroundNode)
		
		// Create and attach the palette button nodes
		for type in Palette.buttonTypesArray {
			
			// Create
			let buttonImage = type.getSpriteImageName()
			let buttonNode = PaletteButton(imageNamed: buttonImage, funcType: type, size: Palette.paletteButtonSize)
			
			// Set position according to offsets
			buttonNode.position = CGPoint(x: buttonX, y: buttonY)
			buttonY -= Palette.paletteButtonWidth + Palette.paletteButtonMargin
			
			// Add node
			self.addChild(buttonNode)
			self.buttonArray.append(buttonNode)
		}
	}
	
	public func assignDelegateForButtons(_ delegate: PaletteButtonDelegate) {
		for button in buttonArray {
			button.setDelegate(delegate)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}




