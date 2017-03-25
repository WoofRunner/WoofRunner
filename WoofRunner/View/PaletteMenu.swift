//
//  PaletteMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

struct OverlayConstants {
	static let numberOfPaletteButtons = CGFloat(3)
	static let paletteButtonSize = CGFloat(60)
	static let paletteButtonMargin = CGFloat(15)
	
	static let paletteWidth = paletteButtonSize + (2 * paletteButtonMargin)
	static let paletteHeight = (paletteButtonSize * numberOfPaletteButtons) + ((numberOfPaletteButtons + 1) * paletteButtonMargin)
	
	// NOTE: For SKShapeNode, position (origin) = bottom/left, not center!
	static let paletteOriginX = CGFloat(35)
	static let paletteOriginY = CGFloat(650)
	
	static let paletteCenterX = paletteOriginX + paletteWidth/2
	static let paletteCenterY = paletteOriginY + paletteHeight/2
	
	static let paletteButtonX0 = paletteOriginX + paletteWidth/2 // y-coord for the topmost palette button
	static let paletteButtonY0 = (paletteOriginY + paletteHeight) - (paletteButtonSize/2 + paletteButtonMargin) // x-coord for the topmost palette button
}


class PaletteMenu: SKNode {
	
	let backgroundNode = CustomShapeNodes.getRoundedRectangleNode(height: OverlayConstants.paletteHeight,
		                                                             width: OverlayConstants.paletteWidth,
		                                                             radius: 25,
		                                                             backgroundColor: SKColor(red: 0, green: 0, blue: 0, alpha: 0.95))
	var buttonTypeArray = [PaletteFunctionType]
	
	
	// Set palette background position
	//self.backgroundNode.position = CGPoint(x: OverlayConstants.paletteOriginX,
	//y: OverlayConstants.paletteOriginY)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
