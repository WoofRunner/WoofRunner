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
			return "testPaletteButton"
		case .obstacle:
			return "testObstaclePaletteButton"
		case .delete:
			return "testDeletePaletteButton"
		}
	}
}
