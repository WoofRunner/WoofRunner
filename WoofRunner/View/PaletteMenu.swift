//
//  PaletteMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

struct PaletteConstants {
	static let buttonTypesArray: [PaletteFunctionType] = [.platform, .obstacle, .delete]
	static let numberOfPaletteButtons = CGFloat(buttonTypesArray.count)
	static let paletteButtonWidth = CGFloat(60)
	static let paletteButtonHeight = CGFloat(60)
	static let paletteButtonSize = CGSize(width: paletteButtonWidth, height: paletteButtonHeight)
	static let paletteButtonMargin = CGFloat(15)
	
	static let paletteWidth = paletteButtonWidth + (2 * paletteButtonMargin)
	static let paletteHeight = (paletteButtonWidth * numberOfPaletteButtons) + ((numberOfPaletteButtons + 1) * paletteButtonMargin)
	
	// The bottom-left corner of the palette's frame
	static let palettePosition = CGPoint(x: 60, y: 680)
	
	static let paletteButtonX0 = paletteWidth/2 // y-coord for the topmost palette button
	static let paletteButtonY0 = paletteHeight - (paletteButtonWidth/2 + paletteButtonMargin) // x-coord for the topmost palette button
	
	static let paletteBackgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.95)
}


class PaletteMenu: SKNode {
	
	let backgroundNode = CustomShapeNodes.getRoundedRectangleNode(height: PaletteConstants.paletteHeight,
		                                                             width: PaletteConstants.paletteWidth,
		                                                             radius: 25,
		                                                             backgroundColor: PaletteConstants.paletteBackgroundColor)
	//var buttonTypesArray = [PaletteFunctionType]()
	
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
		
		self.position = PaletteConstants.palettePosition
		
		// Base x and y positions for the palette buttons
		var buttonY = PaletteConstants.paletteButtonY0
		let buttonX = PaletteConstants.paletteButtonX0
		
		// Attach background first
		self.addChild(backgroundNode)
		
		// Create and attach the palette button nodes
		for type in PaletteConstants.buttonTypesArray {
			
			// Create
			let buttonImage = PaletteButton.getImageNameFromType(type)
			let buttonNode = PaletteButton(imageNamed: buttonImage, funcType: type, size: PaletteConstants.paletteButtonSize)
			
			// Set position according to offsets
			buttonNode.position = CGPoint(x: buttonX, y: buttonY)
			buttonY -= PaletteConstants.paletteButtonWidth + PaletteConstants.paletteButtonMargin
			
			// Add node
			self.addChild(buttonNode)
		}
	
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}




