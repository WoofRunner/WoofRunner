//
//  LevelDesignerPaletteFunctionType.swift
//  WoofRunner
//
//  Created by See Loo Jane on 21/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

enum PaletteFunctionType {
	case platform, obstacle, delete
	
	func getSpriteImageName() -> String {
		switch self {
		case .platform:
			return "add-platform-button"
		case .obstacle:
			return "add-obstacle-button2"
		case .delete:
			return "delete-button"
		}
	}
	
	func getOverlayMenuName() -> String {
		switch self {
		case .platform:
			return "Platforms"
		case .obstacle:
			return "Obstacles"
		default:
			return ""
		}
	}
}
