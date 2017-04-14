//
//  LDOverlayButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 1/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/**
Tappable button in the LevelDesignerOverlayScene
*/
protocol LDOverlayButton {
	
	/**
	Performs the tap logic when the button is pressed
	*/
	func onTap()
}
