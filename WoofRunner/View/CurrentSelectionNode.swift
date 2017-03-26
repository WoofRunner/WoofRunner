//
//  CurrentSelectionNode.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

struct SelectionConstants {
	static let headerFontName = "AvenirNextCondensed-Bold"
	static let headerFontColor = UIColor.white
	static let headerFontSize = CGFloat(25)
	static let spacingBetweenHeaders = CGFloat(25)
	
	static let selectionFontName = "AvenirNextCondensed-Bold"
	static let selectionFontColor = UIColor.lightGray
	static let selectionFontSize = CGFloat(20)
	static let spacingBetweenHeaderAndSelection = CGFloat(60)
}

class CurrentSelectionNode: SKNode {
	
	var headerCurrentLabel = SKLabelNode()
	var headerSelectionLabel = SKLabelNode()
	var selectionLabel = SKLabelNode()
	
	override init() {
		super.init()
		headerCurrentLabel = SKLabelNode(text: "Current")
		configureHeaderLabel(headerCurrentLabel)
		
		headerSelectionLabel = SKLabelNode(text: "Selection:")
		configureHeaderLabel(headerSelectionLabel)
		headerSelectionLabel.position = CGPoint(x: 0, y: -1 * SelectionConstants.spacingBetweenHeaders)
		
		selectionLabel = SKLabelNode(text: "Floor")
		configureSelectionLabel()
		selectionLabel.position = CGPoint(x: 0, y: -1 * SelectionConstants.spacingBetweenHeaderAndSelection)
		
		self.addChild(headerCurrentLabel)
		self.addChild(headerSelectionLabel)
		self.addChild(selectionLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	private func configureHeaderLabel(_ label: SKLabelNode) {
		label.fontName = SelectionConstants.headerFontName
		label.fontColor = SelectionConstants.headerFontColor
		label.fontSize = SelectionConstants.headerFontSize
	}
	
	private func configureSelectionLabel() {
		selectionLabel.fontName = SelectionConstants.selectionFontName
		selectionLabel.fontColor = SelectionConstants.selectionFontColor
		selectionLabel.fontSize = SelectionConstants.selectionFontSize
	}
	
	public func updateSelectionText(_ text: String) {
		selectionLabel.text = text
	}
}
