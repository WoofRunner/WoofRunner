//
//  OverlaySubsectionViewModel.swift
//  WoofRunner
//
//  Created by See Loo Jane on 7/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

/**
Contains the variables required to render an OverlaySubsection
*/
struct OverlaySubsectionViewModel {
	private(set) var title: String
	private(set) var set: [TileType]
	
	init(title: String, set: [TileType]) {
		self.title = title
		self.set = set
	}
	
}
