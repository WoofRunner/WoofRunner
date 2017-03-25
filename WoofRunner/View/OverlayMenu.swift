//
//  OverlayMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

struct OverlayConstants {
	static let screenSize = UIScreen.main.bounds
}


class OverlayMenu: SKNode {
	
	let backgroundNode = SKSpriteNode(texture: nil, color: UIColor.black, size: CGSize(width: OverlayConstants.screenSize.width, height: OverlayConstants.screenSize.height))
	
	override init() {
		super.init()
	}
	
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
		for type in PaletteConstants.buttonTypes {
			
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
