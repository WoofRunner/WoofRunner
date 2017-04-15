//
//  CustomLevelSelectorCardView.swift
//  WoofRunner
//
//  Created by See Loo Jane on 8/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SnapKit
import UIKit

/**
To be displayed for every item in the CustomLevelSelectorViewController carousel view
*/
class CustomLevelSelectorCard: LevelCardView {

	// Buttons require public access to set handlers in VC
	var editButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	var deleteButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	var uploadButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	
	private var authorLabel = UILabel()
	private var playIconOverlay = UIImageView()
	
	// MARK: - Override methods to customise LevelCardView
	
	override internal func didLoad() {
		super.didLoad()
		initialiseAuthorLabel()
		initialiseEditButton()
		initialiseDeleteButton()
		initialiseUploadButton()
		initialiseOverlayIcon()
	}
	
	override public func setupView(vm: LevelCardViewModel) {
		super.setupView(vm: vm)
		setupAuthorLabel(viewModel: vm)
		setupPlayIconOverlay(viewModel: vm)
	}
	
	override internal func bindUUIDToButtons(_ uuid: String) {
		super.bindUUIDToButtons(uuid)
		editButton.bindUUID(uuid)
		deleteButton.bindUUID(uuid)
		uploadButton.bindUUID(uuid)
	}
	
	// MARK: - Private helper Methods
	
	private func initialiseAuthorLabel() {
		addSubview(authorLabel)
		authorLabel.sizeToFit()
		
		// Set Constraints for author label
		authorLabel.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-15)
		}
	}
	
	private func initialiseEditButton() {
		addSubview(editButton)
		editButton.setImage(UIImage(named: "ls-edit-button"), for: .normal)
		editButton.snp.makeConstraints { (make) -> Void in
			make.bottom.equalToSuperview().offset(-90)
			make.left.equalToSuperview().offset(80)
		}
	}
	
	private func initialiseDeleteButton() {
		addSubview(deleteButton)
		deleteButton.setImage(UIImage(named: "ls-delete-button"), for: .normal)
		deleteButton.snp.makeConstraints { (make) -> Void in
			make.bottom.equalToSuperview().offset(-90)
			make.left.equalToSuperview().offset(310)
		}
	}
	
	private func initialiseUploadButton() {
		addSubview(uploadButton)
		uploadButton.setImage(UIImage(named: "upload-button"), for: .normal)
		uploadButton.snp.makeConstraints { (make) -> Void in
			make.bottom.equalToSuperview().offset(-90)
			make.left.equalToSuperview().offset(550)
		}
	}
	
	private func initialiseOverlayIcon() {
		levelImageView.addSubview(playIconOverlay)
		playIconOverlay.snp.makeConstraints { (make) -> Void in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview()
		}
	}
	
	private func setupAuthorLabel(viewModel: LevelCardViewModel) {
		authorLabel.text = "Level Created By \(viewModel.author)"
		authorLabel.font = viewModel.authorLabelFont
		authorLabel.textColor = viewModel.authorLabelColor
	}
	
	private func setupPlayIconOverlay(viewModel: LevelCardViewModel) {
		playIconOverlay.image = UIImage(named: viewModel.playIconImageUrl)
	}
	
}
