//
//  LevelCardViewModel.swift
//  WoofRunner
//
//  Created by See Loo Jane on 1/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import UIKit

public class LevelCardViewModel {
	
	private(set) var levelUUID: String // For tap handler
	
	// Level Name
	private(set) var levelName: String
	private(set) var levelNameLabelColor = StubLevelCardConstants.levelTitleColor
	private(set) var levelNameLabelFont = StubLevelCardConstants.levelTitleFont
	private(set) var levelNameStrokeColor = StubLevelCardConstants.levelNameStrokeColor
	private(set) var levelNameStrokeSize = StubLevelCardConstants.levelNameStrokeSize
	
	// Level image
	private(set) var levelImageUrl: String
	private(set) var imageRectSize = StubLevelCardConstants.levelImageSize
	
	// Player Score
	private(set) var playerScore: Int
	private(set) var playerScoreLabelColor = StubLevelCardConstants.scoreLabelColor
	private(set) var playerScoreLabelFont = StubLevelCardConstants.scoreLabelFont
	
	// Author
	private(set) var author = "You"
	private(set) var authorLabelFont = StubLevelCardConstants.authorLabelFont
	private(set) var authorLabelColor = StubLevelCardConstants.authorLabelColor
	
	init(game: StoredGame) {
		self.levelUUID = game.uuid!
		self.levelName = game.name ?? "No Title"
		self.levelImageUrl = "test-level-image" // Stub
		self.playerScore = StubLevelCardConstants.stubPlayerScore // Stub
		self.author = game.owner
	}

    init(game: DisplayedGame) {
        self.levelUUID = game.id
        // TODO: Add name in DisplayedGame
        self.levelName = "Stubbed"
        self.levelImageUrl = "test-level-image" // Stubbed
        self.playerScore = StubLevelCardConstants.stubPlayerScore
        self.author = game.owner
    }
	
	struct StubLevelCardConstants {
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
