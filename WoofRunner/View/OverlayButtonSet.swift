//
//  OverlayButtonSet.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit


class OverlayButtonSet: SKNode {
	
	private var btnLabel = SKLabelNode()
	private var btn = OverlayButton()
	
	override init() {
		super.init()
	}
	
	// Init method will take in TileType and render the nodes for 
	// button label node and button node
	convenience init(type: TileType) {
		self.init()
		let buttonName = OverlayButton.getTileNameFromType(type)
		let imageNamed = OverlayButton.getImageNameFromType(type)
		
		self.btnLabel = SKLabelNode(text: buttonName)
		self.btn = OverlayButton(imageNamed: imageNamed, type: type, size: CGSize(width: OverlayConstants.btnWidth, height: OverlayConstants.btnHeight))
		
		renderOverlayButtonSet()
	}
	
	
	private func renderOverlayButtonSet() {
		// Configure and add name node
		configureToNameLabel(self.btnLabel)
		self.addChild(self.btnLabel)
		
		// Set button position and add node
		self.btn.position = CGPoint(x: OverlayConstants.btnX, y: OverlayConstants.btnY)
		self.addChild(self.btn)
	}
	
	// Sets the font, color, size and position properties of input label
	// to the presets for a button label node
	private func configureToNameLabel(_ label: SKLabelNode) {
		label.fontName = OverlayConstants.btnLabelFontName
		label.fontColor = OverlayConstants.btnLabelFontColor
		label.fontSize = OverlayConstants.btnLabelFontSize
		label.position = OverlayConstants.btnLabelPosition
	}
	
	public func getButtonNode() -> OverlayButton {
		return self.btn
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
