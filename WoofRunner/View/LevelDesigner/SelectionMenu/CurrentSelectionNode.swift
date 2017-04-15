//
//  CurrentSelectionNode.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//
//	CurrentSelectionNode displays the name of the currently selected
//	BrushSelection. Its position should be set by the parent object 
//	that creates it.

import SpriteKit

/**
Displays the name of the currently selected BrushSelection.
Its position should be set by the parent object that creates it.
*/
class CurrentSelectionNode: SKNode {
	
	// CSUI is shorthand for CurrentSelectionUI
	typealias CSUI = LDOverlaySceneConstants.UISelectionConstants
	
	// MARK: - Private Variables
	
	private var backgroundNode = SKNode()
	private var headerCurrentLabel = SKLabelNode()
	private var headerSelectionLabel = SKLabelNode()
	private var selectionLabel = SKLabelNode()
	
	// MARK: - Initialisers 
	
	override init() {
		super.init()
	}
	
	/**
	Creates a CurrentSelectionUI node with the input defaultSelectionText as the initial display text.
	*/
	convenience init(defaultSelectionText: String) {
		self.init()
		initBackground()
		initLabels(defaultSelectionText: defaultSelectionText)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private Methods
	
	private func initBackground() {
		backgroundNode = CustomShapeNodes.getRoundedRectangleNode(height: CSUI.backgroundSize.height,
		                                                          width: CSUI.backgroundSize.width,
		                                                          radius: CSUI.backgroundCornerRadius,
		                                                          backgroundColor: CSUI.backgroundColor)
		backgroundNode.position = CGPoint(x: -CSUI.backgroundSize.width / 2,
		                                  y: -CSUI.backgroundSize.height / 2 + CSUI.backgroundYOffset)
		self.addChild(backgroundNode)
	}
	
	private func initLabels(defaultSelectionText: String) {
		headerCurrentLabel = SKLabelNode(text: "Current")
		configureHeaderLabel(headerCurrentLabel)
		
		headerSelectionLabel = SKLabelNode(text: "Selection:")
		configureHeaderLabel(headerSelectionLabel)
		headerSelectionLabel.position = CSUI.headerPosition
		
		selectionLabel = SKLabelNode(text: defaultSelectionText)
		configureSelectionLabel()
		selectionLabel.position = CSUI.selectionLabelPosition
		
		addLabelNodes()
	}
	
	private func addLabelNodes() {
		self.addChild(headerCurrentLabel)
		self.addChild(headerSelectionLabel)
		self.addChild(selectionLabel)
	}
	
	private func configureHeaderLabel(_ label: SKLabelNode) {
		label.fontName = CSUI.headerFontName
		label.fontColor = CSUI.headerFontColor
		label.fontSize = CSUI.headerFontSize
	}
	
	private func configureSelectionLabel() {
		selectionLabel.fontName = CSUI.selectionFontName
		selectionLabel.fontColor = CSUI.selectionFontColor
		selectionLabel.fontSize = CSUI.selectionFontSize
	}
	
	// MARK: - Public Methods
	
	/**
	Updates the selectionLabel text to the input String
	*/
	public func updateSelectionText(_ text: String) {
		selectionLabel.text = text
	}
}
