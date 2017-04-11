//
//  OverlayButtonSet.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit


class OverlayButtonSet: SKNode {
	
	typealias Constants = LDOverlaySceneConstants.OverlayConstants
	
	private var btnLabel = SKLabelNode()
	private var btn = OverlayButton()
	
	override init() {
		super.init()
	}
	
	// Initialises a button with the input imageName and a display label
	// with the input name text
	convenience init(name: String, imageNamed: String) {
		self.init()
		let buttonName = name
		let imageNamed = imageNamed
		
		self.btnLabel = SKLabelNode(text: buttonName)
		self.btn = OverlayButton(imageNamed: imageNamed, tileName: buttonName, size: CGSize(width: Constants.btnWidth, height: Constants.btnHeight))
		
		renderOverlayButtonSet()
	}
	
	
	private func renderOverlayButtonSet() {
		// Configure and add name node
		configureToNameLabel(self.btnLabel)
		self.addChild(self.btnLabel)
		
		// Set button position and add node
		self.btn.position = CGPoint(x: Constants.btnX, y: Constants.btnY)
		self.addChild(self.btn)
	}
	
	// Sets the font, color, size and position properties of input label
	// to the presets for a button label node
	private func configureToNameLabel(_ label: SKLabelNode) {
		label.fontName = Constants.btnLabelFontName
		label.fontColor = Constants.btnLabelFontColor
		label.fontSize = Constants.btnLabelFontSize
		label.position = Constants.btnLabelPosition
	}
	
	public func getButtonNode() -> OverlayButton {
		return self.btn
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
