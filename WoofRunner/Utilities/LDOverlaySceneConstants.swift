//
//  LDOverlaySceneConstants.swift
//  WoofRunner
//
//  Created by See Loo Jane on 11/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

struct LDOverlaySceneConstants {
	
	struct PaletteConstants {
		static let buttonTypesArray: [PaletteFunctionType] = [.platform, .obstacle, .delete]
		static let numberOfPaletteButtons = CGFloat(buttonTypesArray.count)
		
		// Palette Buttons
		static let paletteButtonWidth = CGFloat(60)
		static let paletteButtonHeight = CGFloat(60)
		static let paletteButtonSize = CGSize(width: paletteButtonWidth, height: paletteButtonHeight)
		static let paletteButtonMargin = CGFloat(15)
		
		// Palette Menu
		static let paletteWidth = paletteButtonWidth + (2 * paletteButtonMargin)
		static let paletteHeight = (paletteButtonWidth * numberOfPaletteButtons) + ((numberOfPaletteButtons + 1) * paletteButtonMargin)
		static let paletteBackgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.8)
		static let backgroundCornerRadius = CGFloat(25)
		
		// The bottom-left corner of the palette's frame
		static let palettePosition = CGPoint(x: 45, y: 680)
		
		static let paletteButtonX0 = paletteWidth/2 // y-coord for the topmost palette button
		static let paletteButtonY0 = paletteHeight - (paletteButtonWidth/2 + paletteButtonMargin) // x-coord for the topmost palette button
	}
	
	
}
