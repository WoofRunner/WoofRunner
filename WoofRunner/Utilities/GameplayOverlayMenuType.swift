//
//  GameplayOverlayMenuType.swift
//  WoofRunner
//
//  Created by See Loo Jane on 10/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

enum GameplayOverlayMenuType {
	case pause, win, lose
	
	func getSpritePath() -> String {
		switch self {
		case .pause :
			return "pause-menu-bg"
		case .win :
			return "pause-menu-bg"
		case .lose :
			return "pause-menu-bg"
		}
	}
}
