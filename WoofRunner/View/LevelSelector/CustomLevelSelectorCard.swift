//
//  CustomLevelSelectorCard.swift
//  WoofRunner
//
//  Created by See Loo Jane on 8/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SnapKit
import UIKit

class CustomLevelSelectorCard: UIView {
	var levelImageView = LevelSelectorItemImageView() // Public access to set Tap Handler Gesture
	private var levelNameLabel = StrokedLabel()
	private var playerScoreLabel = UILabel()
	private var authorLabel = UILabel()
	
	var editButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
	var deleteButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	var uploadButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	
	
	// MARK: - Initialisers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		didLoad()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		didLoad()
	}
	
	private func didLoad() {
		
		addSubview(levelImageView)
		addSubview(levelNameLabel)
		addSubview(playerScoreLabel)
		addSubview(authorLabel)
		
		levelNameLabel.sizeToFit()
		playerScoreLabel.sizeToFit()
		authorLabel.sizeToFit()
		
		setShadows()
		
		// Set Constraints for level image
		levelImageView.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.topMargin.equalTo(self).offset(170)
		}
		
		// Set Constraints for Level Name label
		levelNameLabel.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.topMargin.equalTo(self).offset(80)
		}
		
		
		// Set Constraints for score label
		playerScoreLabel.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-190)
		}
		
		// Set Constraints for author label
		authorLabel.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-15)
		}
		
		// Add and configure Edit button
		addSubview(editButton)
		editButton.setImage(UIImage(named: "ls-edit-button"), for: .normal)
		editButton.snp.makeConstraints { (make) -> Void in
			make.bottom.equalToSuperview().offset(-90)
			make.left.equalToSuperview().offset(80)
		}
		
		
		// Add and configure debug Delete button
		addSubview(deleteButton)
		deleteButton.setImage(UIImage(named: "ls-delete-button"), for: .normal)
		deleteButton.snp.makeConstraints { (make) -> Void in
			make.bottom.equalToSuperview().offset(-90)
			make.left.equalToSuperview().offset(310)
		}
		
		
		// Add and configure debug Upload button
		addSubview(uploadButton)
		uploadButton.setImage(UIImage(named: "upload-button"), for: .normal)
		uploadButton.snp.makeConstraints { (make) -> Void in
			make.bottom.equalToSuperview().offset(-90)
			make.left.equalToSuperview().offset(550)
		}
		
	}
	
	
	// MARK: - Public Method
	
	// Call this method to setup the View using the input view model object
	public func setupView(vm: LevelCardViewModel) {
		self.backgroundColor = UIColor.clear
	
		// Setup Child Views
		setupLevelNameLabel(viewModel: vm)
		setupScoreLabel(viewModel: vm)
		setupAuthorLabel(viewModel: vm)
		setupImageView(viewModel: vm)
		
		// Bind current item's UUID to the buttons for callbacks later
		bindUUIDToButtons(vm.levelUUID)
		
		setShadows()
	}
	
	// MARK: - Private Helper Methods
	
	private func setupLevelNameLabel(viewModel: LevelCardViewModel) {
		levelNameLabel.text = viewModel.levelName
		levelNameLabel.strokedText(strokeColor: viewModel.levelNameStrokeColor,
		                           fontColor: viewModel.levelNameLabelColor,
		                           strokeSize: viewModel.levelNameStrokeSize,
		                           font: viewModel.levelNameLabelFont!)
		levelNameLabel.font = viewModel.levelNameLabelFont
		levelNameLabel.textColor = viewModel.levelNameLabelColor
	}
	
	private func setupScoreLabel(viewModel: LevelCardViewModel) {
		playerScoreLabel.text = "\(viewModel.playerScore)%"
		playerScoreLabel.font = viewModel.playerScoreLabelFont
		playerScoreLabel.textColor = viewModel.playerScoreLabelColor
	}
	
	private func setupAuthorLabel(viewModel: LevelCardViewModel) {
		authorLabel.text = "Level Created By \(viewModel.author)"
		authorLabel.font = viewModel.authorLabelFont
		authorLabel.textColor = viewModel.authorLabelColor
	}
	
	private func setupImageView(viewModel: LevelCardViewModel) {
		
		// Resizes the image while keeping the aspect ratio
		let resized = UIImage(named: viewModel.levelImageUrl)?
					.resizedImageWithinRect(rectSize: viewModel.imageRectSize)
		levelImageView.image = resized
		levelImageView.isUserInteractionEnabled = true
	}
	
	private func bindUUIDToButtons(_ uuid: String) {
		editButton.bindUUID(uuid)
		levelImageView.bindUUID(uuid)
		deleteButton.bindUUID(uuid)
		uploadButton.bindUUID(uuid)
	}
	
	// TODO: Check why 1st 2 items do not have shadow rendered. Sth to do with recycling in iCarousel
	private func setShadows() {
		configureImageViewShadow()
		configureLabelShadow()
	}
	
	private func configureLabelShadow() {
		playerScoreLabel.setShadow()
		levelNameLabel.setShadow()
	}
	
	private func configureImageViewShadow() {
		levelImageView.setShadow()
	}
}
