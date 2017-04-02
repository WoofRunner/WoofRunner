//
//  OverlayButtonDelegate.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

protocol OverlayButtonDelegate {
	func setCurrentTileSelection(_ type: TileType?)
	func closeOverlayMenu()
}
