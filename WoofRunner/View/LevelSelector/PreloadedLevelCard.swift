//
//  PreloadedLevelCard.swift
//  WoofRunner
//
//  Created by See Loo Jane on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SnapKit

/**
To be displayed for each item in the LevelSelectorViewController carousel view
*/
class PreloadedLevelCard: LevelCardView {

	var playButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	private var playIconOverlay = UIImageView()
	
	// MARK: - Methods to customise view
	
	/**
	Override method to initialise more child views
	*/
	override internal func didLoad() {
		super.didLoad()
		initialisePlayIconOverlay()
		initialisePlayButton()
	}
	
	/**
	Override method to setup more child views using the view model
	*/
	override internal func setupView(vm: LevelCardViewModel) {
		super.setupView(vm: vm)
		setupPlayIconOverlay(viewModel: vm)
	}
	
	/**
	Override method to bind more buttons to level uuid
	*/
	override internal func bindUUIDToButtons(_ uuid: String) {
		super.bindUUIDToButtons(uuid)
		playButton.bindUUID(uuid)
	}
	
	// MARK: - Private helper methods
	
	private func initialisePlayIconOverlay() {
		levelImageView.addSubview(playIconOverlay)
		
		// Set Constraints for play overlay icon
		playIconOverlay.snp.makeConstraints { (make) -> Void in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview()
		}
	}
	
	private func initialisePlayButton() {
		addSubview(playButton)
		playButton.setImage(UIImage(named: "play-btn"), for: .normal)
		playButton.snp.makeConstraints { (make) -> Void in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().offset(-40)
		}
	}
	
	private func setupPlayIconOverlay(viewModel: LevelCardViewModel) {
		playIconOverlay.image = UIImage(named: viewModel.playIconImageUrl)
	}
	
}
