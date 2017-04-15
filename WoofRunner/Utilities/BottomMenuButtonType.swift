//
//  BottomMenuButtonType.swift
//  WoofRunner
//
//  Created by See Loo Jane on 2/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

/**
To describe the function type of BottomMenuButtons 
*/
enum BottomMenuButtonType {
	case save, back, rename
	
	func getImageSprite() -> String {
		switch self {
		case .save:
			return "save-level-button"
		case .back:
			return "back-button"
		default:
			return ""
		}
	}
}
