//
//  MarketplaceLevelCard.swift
//  WoofRunner
//
//  Created by See Loo Jane on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

class MarketplaceLevelCard: LevelCardView {
	private var authorLabel = UILabel()
	var downloadButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
	
	// MARK: - Overridden Methods for Customisation
	
	override internal func didLoad() {
		super.didLoad()
		addSubview(authorLabel)
		authorLabel.sizeToFit()
		
		// Set Constraints for author label
		authorLabel.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-15)
		}
		
		// Add and configure debug Download button
		addSubview(downloadButton)
		downloadButton.setImage(UIImage(named: "download-button"), for: .normal)
		downloadButton.snp.makeConstraints { (make) -> Void in
			make.bottom.equalToSuperview().offset(-90)
			make.centerX.equalToSuperview()
		}
		
	}
	
	override public func setupView(vm: LevelCardViewModel) {
		super.setupView(vm: vm)
		setupAuthorLabel(viewModel: vm)
	}
	
	override internal func bindUUIDToButtons(_ uuid: String) {
		super.bindUUIDToButtons(uuid)
		downloadButton.bindUUID(uuid)
	}
	
	// MARK: - Private Helper Methods
	
	private func setupAuthorLabel(viewModel: LevelCardViewModel) {
		authorLabel.text = "Level Created By \(viewModel.author)"
		authorLabel.font = viewModel.authorLabelFont
		authorLabel.textColor = viewModel.authorLabelColor
	}
	
	
	
}
