//
//  OverlayButtonSet.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

/**
Parents an OverlayButton node and a label describing the button.
Its position should be set by the parent that created this object.
*/
class OverlayButtonSet: SKNode {
	
	typealias Constants = LDOverlaySceneConstants.OverlayConstants
	
	// MARK: - Private Variables
	
	private var btnLabel = SKLabelNode()
	private var btn = OverlayButton()
	
	// MARK: - Initialisers
	
	override init() {
		super.init()
	}
	
	/**
	Initialises a button with the input imageName and a display label with the input name text
	*/
	convenience init(name: String, imageNamed: String) {
		self.init()
		let buttonName = name
		let imageNamed = imageNamed
		
		self.btnLabel = SKLabelNode(text: buttonName)
		self.btn = OverlayButton(imageNamed: imageNamed, tileName: buttonName, size: CGSize(width: Constants.btnWidth, height: Constants.btnHeight))
		
		renderOverlayButtonSet()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private View Set Up Methods
	
	private func renderOverlayButtonSet() {
		// Configure and add name node
		configureNameLabel(self.btnLabel)
		self.addChild(self.btnLabel)
		
		// Set button position and add node
		self.btn.position = CGPoint(x: Constants.btnX, y: Constants.btnY)
		self.addChild(self.btn)
	}
	
	private func configureNameLabel(_ label: SKLabelNode) {
		label.fontName = Constants.btnLabelFontName
		label.fontColor = Constants.btnLabelFontColor
		label.fontSize = Constants.btnLabelFontSize
		label.position = Constants.btnLabelPosition
	}
	
	// MARK: - Public Methods
	
	/**
	Returns the OverlayButton child node
	*/
	public func getButtonNode() -> OverlayButton {
		return self.btn
	}
	
}
