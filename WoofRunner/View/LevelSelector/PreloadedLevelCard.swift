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

	var playButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	
	private var playIconOverlay = UIImageView()
	
	
	override internal func didLoad() {
		super.didLoad()
		levelImageView.addSubview(playIconOverlay)
		

		// Set Constraints for play overlay icon
		playIconOverlay.snp.makeConstraints { (make) -> Void in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview()
		}
		
		// Add and configure debug Play button
		addSubview(playButton)
		playButton.setImage(UIImage(named: "play-btn"), for: .normal)
		playButton.snp.makeConstraints { (make) -> Void in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().offset(-40)
		}
	}
	
	override internal func setupView(vm: LevelCardViewModel) {
		super.setupView(vm: vm)
		setupPlayIconOverlay(viewModel: vm)
	}
	
	override internal func bindUUIDToButtons(_ uuid: String) {
		super.bindUUIDToButtons(uuid)
		playButton.bindUUID(uuid)
	}
	
	private func setupPlayIconOverlay(viewModel: LevelCardViewModel) {
		playIconOverlay.image = UIImage(named: viewModel.playIconImageUrl)
	}
	
}
