//
//  PreloadedLevelCardViewModel.swift
//  WoofRunner
//
//  Created by See Loo Jane on 1/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import UIKit

class PreloadedLevelCardViewModel {
	
	private(set) var levelUUID: String // For tap handler
	
	// Level Name
	private(set) var levelName: String
	private(set) var levelNameLabelColor = StubPreloadedLevelCardConstants.levelTitleColor
	private(set) var levelNameLabelFont = StubPreloadedLevelCardConstants.levelTitleFont
	private(set) var levelNameStrokeColor = StubPreloadedLevelCardConstants.levelNameStrokeColor
	private(set) var levelNameStrokeSize = StubPreloadedLevelCardConstants.levelNameStrokeSize
	
	// Level image
	private(set) var levelImageUrl: String
	private(set) var imageRectSize = StubPreloadedLevelCardConstants.levelImageSize
	
	// Player Score
	private(set) var playerScore: Int
	private(set) var playerScoreLabelColor = StubPreloadedLevelCardConstants.scoreLabelColor
	private(set) var playerScoreLabelFont = StubPreloadedLevelCardConstants.scoreLabelFont
	
	// Author
	private(set) var author = "You"
	private(set) var authorLabelFont = StubPreloadedLevelCardConstants.authorLabelFont
	private(set) var authorLabelColor = StubPreloadedLevelCardConstants.authorLabelColor
	
	init(game: StoredGame) {
		self.levelUUID = game.uuid!
		
		// Get substring of uuid to act as level name for now
		let str = game.uuid!
		let index = str.index(str.startIndex, offsetBy: 5)
		self.levelName = str.substring(to: index)
		
		self.levelImageUrl = "test-level-image" // Stub
		self.playerScore = StubPreloadedLevelCardConstants.stubPlayerScore // Stub
		
		/* Uncomment once author variable is availabel in StoredGame
		if let author = game.author {
			self.author = author
		}
		*/
	}
	
	struct StubPreloadedLevelCardConstants {
		// Level Title
		static let levelTitleColor = UIColor(red: 0.96, green: 0.87, blue: 0.72, alpha: 1.0)
		static let levelTitleFont = UIFont(name: "AvenirNext-Bold", size: 40)
		static let levelNameStrokeColor = UIColor(red: 0.78, green: 0.47, blue: 0.20, alpha: 1.0)
		static let levelNameStrokeSize = CGFloat(4.0)
		
		// Player Score
		static let scoreLabelColor = UIColor(red: 0.85, green: 0.82, blue: 0.91, alpha: 1.0)
		static let scoreLabelFont = UIFont(name: "AvenirNext-Bold", size: 65)
		static let stubPlayerScore = 47
		
		// Author
		static let authorLabelColor = UIColor(red: 0.85, green: 0.82, blue: 0.91, alpha: 0.65)
		static let authorLabelFont = UIFont(name: "AvenirNext-Bold", size: 28)
		
		// Level Image
		static let levelImageSize = CGSize(width: 600, height: 550)
		
	}
	
	
}
