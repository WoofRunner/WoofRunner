//
//  CurrentSelectionNode.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

struct SelectionConstants {
	
	static let menuSize = CGSize()
	static let backgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.8)
	static let backgroundCornerRadius = CGFloat(25)
	static let backgroundSize = CGSize(width: 200, height: 130)
	static let backgroundYOffset = CGFloat(-15)
	
	static let headerFontName = "AvenirNextCondensed-Bold"
	static let headerFontColor = UIColor.white
	static let headerFontSize = CGFloat(25)
	static let spacingBetweenHeaders = CGFloat(25)
	
	static let selectionFontName = "AvenirNextCondensed-Bold"
	static let selectionFontColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
	static let selectionFontSize = CGFloat(20)
	static let spacingBetweenHeaderAndSelection = CGFloat(60)
}

class CurrentSelectionNode: SKNode {
	
	var backgroundNode = SKNode()
	var headerCurrentLabel = SKLabelNode()
	var headerSelectionLabel = SKLabelNode()
	var selectionLabel = SKLabelNode()
	
	override init() {
		super.init()
	}
	
	convenience init(defaultSelectionText: String) {
		self.init()
		initBackground()
		initLabels(defaultSelectionText: defaultSelectionText)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	private func addLabelNodes() {
		self.addChild(headerCurrentLabel)
		self.addChild(headerSelectionLabel)
		self.addChild(selectionLabel)
	}
	
	private func initBackground() {
		backgroundNode = CustomShapeNodes.getRoundedRectangleNode(height: SelectionConstants.backgroundSize.height,
		                                                          width: SelectionConstants.backgroundSize.width,
		                                                          radius: SelectionConstants.backgroundCornerRadius,
		                                                          backgroundColor: SelectionConstants.backgroundColor)
		backgroundNode.position = CGPoint(x: -SelectionConstants.backgroundSize.width / 2,
		                                  y: -SelectionConstants.backgroundSize.height / 2 + SelectionConstants.backgroundYOffset)
		self.addChild(backgroundNode)
	}
	
	private func initLabels(defaultSelectionText: String) {
		headerCurrentLabel = SKLabelNode(text: "Current")
		configureHeaderLabel(headerCurrentLabel)
		
		headerSelectionLabel = SKLabelNode(text: "Selection:")
		configureHeaderLabel(headerSelectionLabel)
		headerSelectionLabel.position = CGPoint(x: 0, y: -1 * SelectionConstants.spacingBetweenHeaders)
		
		selectionLabel = SKLabelNode(text: defaultSelectionText)
		configureSelectionLabel()
		selectionLabel.position = CGPoint(x: 0, y: -1 * SelectionConstants.spacingBetweenHeaderAndSelection)
		
		addLabelNodes()
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
