//
//  LSListItemViewModel.swift
//  WoofRunner
//
//  Created by See Loo Jane on 1/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import UIKit

class LSListItemViewModel {
	
	private(set) var levelUUID: String // For tap handler
	
	private(set) var levelName: String
	private(set) var levelNameLabelColor = StubLSConstants.levelTitleColor
	private(set) var levelNameLabelFont = StubLSConstants.levelTitleFont
	
	private(set) var levelImageUrl: String
	private(set) var imageRectSize = StubLSConstants.levelImageSize
	
	private(set) var playerScore: Int
	private(set) var playerScoreLabelColor = StubLSConstants.scoreLabelColor
	private(set) var playerScoreLabelFont = StubLSConstants.scoreLabelFont
	
	init(game: StoredGame) {
		self.levelUUID = game.uuid!
		
		// Get substring of uuid to act as level name for now
		let str = game.uuid!
		let index = str.index(str.startIndex, offsetBy: 5)
		self.levelName = str.substring(to: index)
		
		self.levelImageUrl = "test-level-image" // Stub
		self.playerScore = StubLSConstants.stubPlayerScore // Stub
	}
	
	struct StubLSConstants {
		static let levelTitleColor = UIColor(red: 0.56, green: 0.30, blue: 0.72, alpha: 0.8)
		static let scoreLabelColor = UIColor(red: 0.85, green: 0.82, blue: 0.91, alpha: 1.0)
		static let levelTitleFont = UIFont(name: "AvenirNext-Bold", size: 40)
		static let scoreLabelFont = UIFont(name: "AvenirNext-Bold", size: 55)
		static let levelImageSize = CGSize(width: 600, height: 600)
		static let stubPlayerScore = 47
	}
	
	
}
