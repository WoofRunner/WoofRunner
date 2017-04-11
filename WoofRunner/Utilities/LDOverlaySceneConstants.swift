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
		static let backgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.8)
		static let backgroundCornerRadius = CGFloat(25)
		
		// The bottom-left corner of the palette's frame
		static let palettePosition = CGPoint(x: 45, y: 680)
		
		static let paletteButtonX0 = paletteWidth/2 // y-coord for the topmost palette button
		static let paletteButtonY0 = paletteHeight - (paletteButtonWidth/2 + paletteButtonMargin) // x-coord for the topmost palette button
	}
	
	struct BottomMenuConstants {
		
		// Bar background
		static let barWidth = UIScreen.main.bounds.width
		static let barHeight = UIScreen.main.bounds.height / 5
		static let backgroundImageName = "bottom-menu-bg"
		static let backgroundColor = UIColor.clear
		
		// Buttons
		static let btnLabelFontName = "AvenirNextCondensed-Bold"
		static let saveBtnLabelFontColor = UIColor.green
		static let testBtnLabelFontColor = UIColor.magenta
		static let btnLabelFontSize = CGFloat(30)
		static let btnSize = CGSize(width: 45, height: 45)
		static let btnXOffset = CGFloat(40)
		static let saveBtnXPosition = barWidth / 2 - btnXOffset
		static let backBtnXPosition = -1 * barWidth / 2 + btnXOffset
		static let btnYPosition = CGFloat(10)
		
		// Label
		static let levelNameLabelFontName = "AvenirNextCondensed-DemiBold"
		static let levelNameLabelFontColor = UIColor.white
		static let levelNameLabelFontSize = CGFloat(45)
		static let defaultLevelName = "Custom Level"
		static let labelPosition = CGPoint(x: 0, y: 0)
	}
	
	struct UISelectionConstants {
		
		// Menu
		static let menuSize = CGSize()
		static let backgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.8)
		static let backgroundCornerRadius = CGFloat(25)
		static let backgroundSize = CGSize(width: 200, height: 130)
		static let backgroundYOffset = CGFloat(-15)
		
		// Header
		static let headerFontName = "AvenirNextCondensed-Bold"
		static let headerFontColor = UIColor.white
		static let headerFontSize = CGFloat(25)
		static let spacingBetweenHeaders = CGFloat(25)
		static let headerPosition = CGPoint(x: 0, y: -1 * spacingBetweenHeaders)
		
		// Selection Label
		static let selectionFontName = "AvenirNextCondensed-Bold"
		static let selectionFontColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
		static let selectionFontSize = CGFloat(20)
		static let spacingBetweenHeaderAndSelection = CGFloat(60)
		static let selectionLabelPosition = CGPoint(x: 0, y: -1 * spacingBetweenHeaderAndSelection)
	}
	
	

	
	
}
