//
//  BottomMenuButtonType.swift
//  WoofRunner
//
//  Created by See Loo Jane on 2/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

enum BottomMenuButtonType {
	case save, back
	
	func getImageSprite() -> String {
		switch self {
		case .save:
			return "save-level-button"
		case .back:
			return "back-button"
		}
	}
}
