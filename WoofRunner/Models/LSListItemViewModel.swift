//
//  LSListItemViewModel.swift
//  WoofRunner
//
//  Created by See Loo Jane on 1/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

class LSListItemViewModel {
	
	private(set) var levelName: String
	private(set) var levelImageUrl: String
	private(set) var playerScore: Int
	
	init(game: StoredGame) {
		self.levelName = game.uuid! // TODO: Current using uuid as stub for level name
		self.levelImageUrl = "" // TODO: Stub
		self.playerScore = 47 // TODO: Stub
	}
	
	
}
