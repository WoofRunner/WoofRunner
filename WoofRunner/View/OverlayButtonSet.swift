//
//  OverlayButtonSet.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class OverlayButtonSet: SKNode {
	
	var buttonName: String = ""
	var btn: OverlayButton = OverlayButton()
	
	override init() {
		super.init()
	}
	
	convenience init(type: TileType, size: CGSize, position: CGPoint) {
		self.init()
		self.buttonName = OverlayButton.getTileNameFromType(type)
		let imageNamed = OverlayButton.getImageNameFromType(type)
		self.btn = OverlayButton(imageNamed: imageNamed, type: type, size: size)
		self.position = position
	}
	
	public func renderOverlayButtonSet() {
		// Create and add name node
		let nameNode = SKLabelNode(text: self.buttonName)
		configureToNameLabel(nameNode)
		self.addChild(nameNode)
		
		// Add Btn Node with offset
		self.btn.position = CGPoint(x: OverlayConstants.btnBasePosX, y: OverlayConstants.btnBasePosX)
		self.addChild(self.btn)
	}
	
	private func configureToNameLabel(_ label: SKLabelNode) {
		label.fontName = OverlayConstants.btnLabelFontName
		label.fontColor = OverlayConstants.btnLabelFontColor
		label.fontSize = OverlayConstants.btnLabelFontSize
		label.position = OverlayConstants.btnLabelBasePosition
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
