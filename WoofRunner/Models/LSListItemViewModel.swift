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
	
	private(set) var levelName: String
	private(set) var levelNameLabelColor = StubLSConstants.levelTitleColor
	private(set) var levelNameLabelFont = StubLSConstants.levelTitleFont
	
	private(set) var levelImageUrl: String
	
	private(set) var playerScore: Int
	private(set) var playerScoreLabelColor = StubLSConstants.scoreLabelColor
	private(set) var playerScoreLabelFont = StubLSConstants.scoreLabelFont
	
	init(game: StoredGame) {
		self.levelName = game.uuid! // TODO: Current using uuid as stub for level name
		self.levelImageUrl = "test-level-image" // TODO: Stub
		self.playerScore = 47 // TODO: Stub
	}
	
	struct StubLSConstants {
		static let levelTitleColor = UIColor(red: 0.40, green: 0.31, blue: 0.65, alpha: 1.0)
		static let scoreLabelColor = UIColor(red: 0.85, green: 0.82, blue: 0.91, alpha: 1.0)
		static let levelTitleFont = UIFont(name: "AvenirNext-Bold", size: 40)
		static let scoreLabelFont = UIFont(name: "AvenirNext-Bold", size: 55)
	}
	
	
}
