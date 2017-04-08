//
//  PreloadedLevelCard.swift
//  WoofRunner
//
//  Created by See Loo Jane on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SnapKit

class PreloadedLevelCard: LevelCardView {

	var editButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // FOR DEBUG ONLY
	
	
	override internal func didLoad() {
		super.didLoad()
		
		// Add and configure debug Edit button
		addSubview(editButton)
		editButton.setTitle("Edit", for: .normal)
		editButton.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-40)
		}
	}
	
	override internal func bindUUIDToButtons(_ uuid: String) {
		super.bindUUIDToButtons(uuid)
		editButton.bindUUID(uuid)
	}
	
}
