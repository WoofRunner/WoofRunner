//
//  LDOverlayMenuViewModel.swift
//  WoofRunner
//
//  Created by See Loo Jane on 8/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

struct LDOverlayMenuViewModel {
	var tileModelArray: [TileModel] = []
	var menuName: String = ""
	
	init(funcType: PaletteFunctionType, allTileModels: [TileModel]) {
		
		self.menuName = funcType.getOverlayMenuName()
		
		
		// Filter list according to the funcType
		switch funcType {
			case .platform:
				for tileModel in allTileModels {
					if let tileModel = tileModel as? PlatformModel {
						self.tileModelArray.append(tileModel)
					}
				}
				
			case .obstacle:
				for tileModel in allTileModels {
					if let tileModel = tileModel as? ObstacleModel {
						self.tileModelArray.append(tileModel)
					}
				}
				
			default:
				return
		}
		
	}
	
}
