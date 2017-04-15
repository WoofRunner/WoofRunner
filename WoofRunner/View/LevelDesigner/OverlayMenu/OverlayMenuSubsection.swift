//
//  OverlayMenuSubsection.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

/**
SKnode that parents a set of OverlayButtonSets. Its position should be 
set by the creator parent class.
*/
class OverlayMenuSubsection: SKNode {
	
	typealias Constants = LDOverlaySceneConstants.OverlayConstants
	
	// MARK: - Private Variables
	
	private var tileModelArray = [TileModel]()
	private var sectionTitleLabel = SKLabelNode()
	private var buttonSetArray = [OverlayButtonSet]() // Required to easily assign delegates to the buttons
	
	// MARK: - Computed Variables
	
	// Height of the entire subsection
	var height: CGFloat {
		let titleHeight = self.sectionTitleLabel.frame.size.height
		var numberOfRows = 1.0
		
		if self.tileModelArray.count >= 3 {
			numberOfRows = ceil(Double(self.tileModelArray.count) / Double(3))
		}
		
		// 60 is the estimated height of the Subsection title
		let btnSetHeight = Constants.btnHeight + Constants.btnMargin
		let height = titleHeight + CGFloat(numberOfRows) * btnSetHeight
		
		return CGFloat(height)
	}
	
	
	// MARK: - Initialisers
	
	override init() {
		super.init()
	}
	
	convenience init(tileModelArray: [TileModel]) {
		self.init()
		self.tileModelArray	= tileModelArray
		renderSubsection()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private View Setup Methods
	
	// Sets up the OverlayBUttonSets given the tileModelArray
	private func renderSubsection() {
		
		// Base X and Y coordinates for the first ButtonSet
		var baseX = Constants.btnSetBaseX
		var baseY = Constants.btnSetBaseY
		
		for i in 0..<tileModelArray.count {
			let tileModel = tileModelArray[i]
			
			// Ignore tile if there is not valid image sprite path
            guard let iconPath = tileModel.iconPath else {
                continue
            }
            
			//Create and attach ButtonSet
			let btnSet = OverlayButtonSet(name: tileModel.name, imageNamed: iconPath)
			
			if i % 3 == 0 {
				baseX = Constants.btnSetBaseX
				baseY = baseY - CGFloat(i) * Constants.btnSetSpacingY
			} else {
				baseX += Constants.btnWidth + Constants.btnSetSpacingX
			}
			btnSet.position = CGPoint(x: baseX , y: baseY)
			self.addChild(btnSet)			
			buttonSetArray.append(btnSet)
		}
	}
	
	
	private func configureToTitleLabel(_ label: SKLabelNode) {
		label.fontName = Constants.subtitleFontName
		label.fontColor = Constants.subtitleFontColor
		label.fontSize = Constants.subtitleFontSize
	}
	
	// MARK: - Public methods
	
	/**
	Assigns the OverlayButtonDelegate for all the OverlayButtons inside this subsection
	*/
	public func assignDelegateForButtons(_ delegate: OverlayButtonDelegate) {
		for buttonSet in buttonSetArray {
			buttonSet.getButtonNode().setDelegate(delegate)
		}
	}
	
	
	
	
}
