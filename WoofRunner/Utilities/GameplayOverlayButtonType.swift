//
//  GameplayOverlayButtonType.swift
//  WoofRunner
//
//  Created by See Loo Jane on 10/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

enum GameplayOverlayButtonType {
	case resume, retry, exit
	
	func getSpritePath() -> String {
		switch self {
		case .resume :
			return "resume-button"
		case .retry :
			return "retry-button"
		case .exit :
			return "exit-pause-button"
		}
	}
}
