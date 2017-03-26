//
//  OverlayMenuSubsection.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class OverlayMenuSubsection: SKNode {
	
	let margin = CGFloat(15)
	
	//var sectionName: String = ""
	var buttonTypeArray = [TileType]()
	
	var sectionTitleLabel = SKLabelNode()
	var buttonSetArray = [OverlayButtonSet]()
	
	override init() {
		super.init()
	}
	
	convenience init(sectionName: String, buttonTypeArray: [TileType]) {
		self.init()
		
		self.sectionTitleLabel = SKLabelNode(text: sectionName)
		self.buttonTypeArray = buttonTypeArray
		
		renderSubsection()
	}
	
	private func renderSubsection() {
		
		// Render Section Title Label
		configureToTitleLabel(self.sectionTitleLabel)
		self.sectionTitleLabel.position = CGPoint(x: OverlayConstants.subsectionTitleX , y: OverlayConstants.subsectionTitleY)
		self.addChild(self.sectionTitleLabel)
		
		// Render ButtonSets
		var baseX = OverlayConstants.btnSetBaseX
		var baseY = OverlayConstants.btnSetBaseY
		
		for i in 0..<buttonTypeArray.count {
			
			let type = buttonTypeArray[i]
			
			//Create
			let btnSet = OverlayButtonSet(type: type)
			
			if i % 3 == 0 {
				baseX = OverlayConstants.btnSetBaseX
				baseY = baseY - CGFloat(i) * OverlayConstants.btnSetSpacingY
			} else {
				baseX += OverlayConstants.btnWidth + OverlayConstants.btnSetSpacingX
			}
			
			// Set Position
			btnSet.position = CGPoint(x: baseX , y: baseY)
			
			// Add Node
			self.addChild(btnSet)
			
			buttonSetArray.append(btnSet)
		}
	}
	
	
	var height: CGFloat {
		let titleHeight = self.sectionTitleLabel.frame.size.height
		
		print("TitleHeight: \(titleHeight)")
		var numberOfRows = 1.0
		
		if self.buttonTypeArray.count >= 3 {
			numberOfRows = ceil(Double(self.buttonTypeArray.count) / Double(3))
		}
		
		let btnSetHeight = OverlayConstants.btnHeight + OverlayConstants.btnMargin + 60
		let height = titleHeight + CGFloat(numberOfRows) * btnSetHeight
		
		//let centerX = origin.x + (size.width / 2)
		//let centerY = origin.y + (size.height / 2)
		return CGFloat(height)
	}
	
	
	private func configureToTitleLabel(_ label: SKLabelNode) {
		label.fontName = OverlayConstants.subtitleFontName
		label.fontColor = OverlayConstants.subtitleFontColor
		label.fontSize = OverlayConstants.subtitleFontSize
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
}
