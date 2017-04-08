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
	
	var editButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	var deleteButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	var uploadButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	
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
		
		// Add and configure debug Edit button
		addSubview(editButton)
		editButton.setImage(UIImage(named: "ls-edit-button"), for: .normal)
		editButton.isUserInteractionEnabled = true
		editButton.snp.makeConstraints { (make) -> Void in
			make.right.equalTo(self).offset(320)
			make.bottom.equalTo(self).offset(-90)
		}
		
		// Add and configure debug Delete button
		addSubview(deleteButton)
		deleteButton.setImage(UIImage(named: "ls-delete-button"), for: .normal)
		editButton.isUserInteractionEnabled = true
		deleteButton.snp.makeConstraints { (make) -> Void in
			make.left.equalTo(self).offset(-430)
			make.bottom.equalTo(self).offset(-90)
		}
		
		// Add and configure debug Upload button
		addSubview(uploadButton)
		uploadButton.setImage(UIImage(named: "upload-button"), for: .normal)
		editButton.isUserInteractionEnabled = true
		uploadButton.snp.makeConstraints { (make) -> Void in
			make.left.equalTo(self).offset(-200)
			make.bottom.equalTo(self).offset(-90)
		}
		
		
	}
	
	public func setupView(vm: PreloadedLevelCardViewModel) {
		
		// Set up Level Name
		levelNameLabel.text = vm.levelName
		levelNameLabel.strokedText(strokeColor: vm.levelNameStrokeColor, fontColor: vm.levelNameLabelColor, strokeSize: vm.levelNameStrokeSize, font: vm.levelNameLabelFont!)
		levelNameLabel.font = vm.levelNameLabelFont
		levelNameLabel.textColor = vm.levelNameLabelColor
		
		// Set up player score
		playerScoreLabel.text = "\(vm.playerScore)%"
		playerScoreLabel.font = vm.playerScoreLabelFont
		playerScoreLabel.textColor = vm.playerScoreLabelColor
		
		// Set up level author
		authorLabel.text = "Level Created By \(vm.author)"
		authorLabel.font = vm.authorLabelFont
		authorLabel.textColor = vm.authorLabelColor
		
		// Resize image
		let resized = UIImage(named: vm.levelImageUrl)?.resizedImageWithinRect(rectSize: vm.imageRectSize)
		levelImageView.image = resized
		levelImageView.isUserInteractionEnabled = true
		
		// Set Shadows
		setShadows()
		
		// Set BG Color
		self.backgroundColor = UIColor.clear
		
		// Binding current item's UUID to the buttons for callbacks later
		editButton.bindUUID(vm.levelUUID)
		levelImageView.bindUUID(vm.levelUUID)
		deleteButton.bindUUID(vm.levelUUID)
		uploadButton.bindUUID(vm.levelUUID)
		
		editButton.isUserInteractionEnabled = true
		deleteButton.isUserInteractionEnabled = true
		uploadButton.isUserInteractionEnabled = true
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
