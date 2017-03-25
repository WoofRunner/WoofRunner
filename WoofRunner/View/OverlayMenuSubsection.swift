//
//  OverlayMenuSubsection.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

struct OverlayMenuSubsectionConstants {
	static let titleFontName = "AvenirNextCondensed-Bold"
	static let titleFontColor = UIColor.white
	static let titleFontSize = CGFloat(40)
	static let titlePosition = CGPoint(x: 0, y: 450)
}

class OverlayMenuSubsection: SKNode {
	
	var sectionName: String = ""
	var buttonTypeArray = [TileType]()
	
	override init() {
		super.init()
	}
	
	convenience init(name: String, buttonTypeArray: [TileType], position: CGPoint) {
		self.init()
		self.sectionName = name
		self.buttonTypeArray = buttonTypeArray
		self.position = position
	}
	
	public func renderSubsection() {
		
		// Render Section Title Label
		let menuTitle = SKLabelNode(text: name)
		configureToTitleLabel(menuTitle)
		
		// Render ButtonSets
		
	}
	
	private func configureToTitleLabel(_ label: SKLabelNode) {
		label.fontName = OverlayMenuSubsectionConstants.titleFontName
		label.fontColor = OverlayMenuSubsectionConstants.titleFontColor
		label.fontSize = OverlayMenuSubsectionConstants.titleFontSize
		label.position = OverlayMenuSubsectionConstants.titlePosition
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
}
