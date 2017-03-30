//
//  LevelDesignerBottomMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 27/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

struct BottomMenuConstants {
	static let barWidth = UIScreen.main.bounds.width
	static let barHeight = UIScreen.main.bounds.height / 11
	
	static let btnLabelFontName = "AvenirNextCondensed-Bold"
	static let saveBtnLabelFontColor = UIColor.green
	static let testBtnLabelFontColor = UIColor.magenta
	static let btnLabelFontSize = CGFloat(30)
	
	static let levelNameLabelFontName = "AvenirNextCondensed-DemiBold"
	static let levelNameLabelFontColor = UIColor.black
	static let levelNameLabelFontSize = CGFloat(45)
}

class LevelDesignerBottomMenu: SKNode {
	
	private let backgroundNode = SKSpriteNode(texture: nil, color: UIColor.white, size: CGSize(width: BottomMenuConstants.barWidth, height: BottomMenuConstants.barHeight))
	private var saveButton = BottomMenuButton(text: "Save")
	private var backButton = BottomMenuButton(text: "Back")
	private var levelNameLabel = SKLabelNode(text: "Custom Level 1")
	
	override init() {
		super.init()
		
		// Attach BG First
		self.addChild(backgroundNode)
		
		// Attach SKLabels
		self.addChild(saveButton)
		self.addChild(backButton)
		self.addChild(levelNameLabel)
		
		configureSaveButtonLabel()
		configureBackButtonLabel()
		configureLevelNameLabel()
		
	}
	
	public func setButtonDelegates(_ delegate: BottomMenuButtonDelegate) {
		self.saveButton.setDelegate(delegate)
		self.backButton.setDelegate(delegate)
	}
	
	
	private func configureSaveButtonLabel() {
		saveButton.fontColor = BottomMenuConstants.saveBtnLabelFontColor
		saveButton.fontName = BottomMenuConstants.btnLabelFontName
		saveButton.fontSize = BottomMenuConstants.btnLabelFontSize
		saveButton.position.x = BottomMenuConstants.barWidth / 2 - CGFloat(40)
	}
	
	private func configureBackButtonLabel() {
		backButton.fontColor = BottomMenuConstants.testBtnLabelFontColor
		backButton.fontName = BottomMenuConstants.btnLabelFontName
		backButton.fontSize = BottomMenuConstants.btnLabelFontSize
		backButton.position.x = -1 * (BottomMenuConstants.barWidth / 2) + CGFloat(40)
	}
	
	private func configureLevelNameLabel() {
		levelNameLabel.fontColor = BottomMenuConstants.levelNameLabelFontColor
		levelNameLabel.fontName = BottomMenuConstants.levelNameLabelFontName
		levelNameLabel.fontSize = BottomMenuConstants.levelNameLabelFontSize
		levelNameLabel.position.x = CGFloat(0)
	}
	
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
