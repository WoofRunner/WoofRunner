//
//  OverlayMenuSubsection.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class OverlayMenuSubsection: SKNode {
	
	private var tileModelArray = [TileModel]()
	private var sectionTitleLabel = SKLabelNode()
	private var buttonSetArray = [OverlayButtonSet]()
	
	override init() {
		super.init()
	}
	
	convenience init(tileModelArray: [TileModel]) {
		self.init()
		
		//self.sectionTitleLabel = SKLabelNode(text: sectionName)
		self.tileModelArray	= tileModelArray
		
		renderSubsection()
	}
	
	private func renderSubsection() {
		
		/*
		// Render Section Title Label
		configureToTitleLabel(self.sectionTitleLabel)
		self.sectionTitleLabel.position = CGPoint(x: OverlayConstants.subsectionTitleX , y: OverlayConstants.subsectionTitleY)
		self.addChild(self.sectionTitleLabel)
		*/
		
		// Render ButtonSets
		var baseX = OverlayConstants.btnSetBaseX
		var baseY = OverlayConstants.btnSetBaseY
		
		for i in 0..<tileModelArray.count {
			
			let tileModel = tileModelArray[i]
			
            guard let iconPath = tileModel.iconPath else {
                continue
            }
            
			//Create
			let btnSet = OverlayButtonSet(name: tileModel.name, imageNamed: iconPath)
			
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
		var numberOfRows = 1.0
		
		if self.tileModelArray.count >= 3 {
			numberOfRows = ceil(Double(self.tileModelArray.count) / Double(3))
		}
		
		// 60 is the estimated height of the Subsection title
		let btnSetHeight = OverlayConstants.btnHeight + OverlayConstants.btnMargin
		let height = titleHeight + CGFloat(numberOfRows) * btnSetHeight

		return CGFloat(height)
	}
		
	private func configureToTitleLabel(_ label: SKLabelNode) {
		label.fontName = OverlayConstants.subtitleFontName
		label.fontColor = OverlayConstants.subtitleFontColor
		label.fontSize = OverlayConstants.subtitleFontSize
	}
	
	public func assignDelegateForButtons(_ delegate: OverlayButtonDelegate) {
		for buttonSet in buttonSetArray {
			buttonSet.getButtonNode().setDelegate(delegate)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
}
