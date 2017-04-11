//
//  LevelDesignerBottomMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 27/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class LevelDesignerBottomMenu: SKNode {
	
	typealias BottomMenu = LDOverlaySceneConstants.BottomMenuConstants
	
	// MARK: - Private Variables
	
	private let backgroundNode = SKSpriteNode(texture: SKTexture(imageNamed: BottomMenu.backgroundImageName),
	                                          color: BottomMenu.backgroundColor,
	                                          size: CGSize(width: BottomMenu.barWidth,
	                                                       height: BottomMenu.barHeight))
	private var saveButton = BottomMenuSpriteButton(type: .save, size: BottomMenu.btnSize)
	private var backButton = BottomMenuSpriteButton(type: .back, size: BottomMenu.btnSize)
	private var levelNameLabel = BottomMenuLabelButton(type: .rename,
	                                                   text: BottomMenu.defaultLevelName)
	
	// MARK: - Initialisers
	
	override init() {
		super.init()
		setupNode()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private Methods
	
	// Setup node upon initialising
	private func setupNode() {
		
		// Attach BG
		self.addChild(backgroundNode)
		
		// Attach Buttons
		self.addChild(saveButton)
		self.addChild(backButton)
		self.addChild(levelNameLabel)
		
		configureSaveButton()
		configureBackButton()
		configureLevelNameLabel()
	}
	
	private func configureSaveButton() {
		saveButton.position.x = BottomMenu.saveBtnXPosition
		saveButton.position.y = BottomMenu.btnYPosition
	}
	
	private func configureBackButton() {
		backButton.position.x = BottomMenu.backBtnXPosition
		backButton.position.y = BottomMenu.btnYPosition
	}
	
	private func configureLevelNameLabel() {
		levelNameLabel.fontColor = BottomMenu.levelNameLabelFontColor
		levelNameLabel.fontName = BottomMenu.levelNameLabelFontName
		levelNameLabel.fontSize = BottomMenu.levelNameLabelFontSize
		levelNameLabel.position = BottomMenu.labelPosition
	}
	
	// MARK: - Public Methods
	
	/**
	Sets the BottomMenuDelegate attribute for all the BottomMenuButtons
	*/
	public func setButtonDelegates(_ delegate: BottomMenuButtonDelegate) {
		self.saveButton.setDelegate(delegate)
		self.backButton.setDelegate(delegate)
		self.levelNameLabel.setDelegate(delegate)
	}
	
	/**
	Sets the currently displayed level name
	*/
	public func setLevelName(_ name: String) {
		levelNameLabel.text = name
	}

	
}
