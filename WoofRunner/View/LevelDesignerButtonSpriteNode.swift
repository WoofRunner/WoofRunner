//
//  LevelDesignerButtonSpriteNode.swift
//  WoofRunner
//
//  Created by See Loo Jane on 19/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SpriteKit

class LevelDesignerButtonSpriteNode: RootSKSpriteNode {
	
	/*
	static let LEVEL_DESIGNER_PALETTE_BUTTON_SIZE = CGFloat(60)
	var diameter: CGFloat = LEVEL_DESIGNER_PALETTE_BUTTON_SIZE
	var type: LevelDesignerPaletteFunctionType = .platform
	
	/*
	self.pauseNode = SKSpriteNode(imageNamed: "testCat")
	self.pauseNode.size = CGSize(width: spriteSize, height: spriteSize)
	self.pauseNode.position = CGPoint(x: spriteSize + 8, y: spriteSize + 8)
	*/
	
	override init(texture: SKTexture!, color: SKColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	convenience init(imageNamed: String, type: LevelDesignerPaletteFunctionType) {
		let size = CGSize(width: LevelDesignerButtonSpriteNode.LEVEL_DESIGNER_PALETTE_BUTTON_SIZE,
		                  height: LevelDesignerButtonSpriteNode.LEVEL_DESIGNER_PALETTE_BUTTON_SIZE)
		self.init(texture: SKTexture(imageNamed: imageNamed), color: SKColor.clear, size: size)
		self.type = type
	}

	
	required init?(coder aDecoder: NSCoder) {
		// Decoding length here would be nice...
		super.init(coder: aDecoder)
	}
	*/
	
}
