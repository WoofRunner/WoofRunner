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
		
		levelNameLabel.sizeToFit()
		playerScoreLabel.sizeToFit()
		
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
			make.bottom.equalTo(self).offset(-40)
		}
		
		// Add and configure debug Edit button
		addSubview(editButton)
		editButton.setTitle("Edit", for: .normal)
		editButton.snp.makeConstraints { (make) -> Void in
			make.left.equalTo(self).offset(-450)
			make.bottom.equalTo(self).offset(-160)
		}
		
		// Add and configure debug Delete button
		addSubview(deleteButton)
		deleteButton.setTitle("Delete", for: .normal)
		deleteButton.snp.makeConstraints { (make) -> Void in
			make.right.equalTo(self).offset(450)
			make.bottom.equalTo(self).offset(-160)
		}
		
		// Add and configure debug Upload button
		addSubview(uploadButton)
		uploadButton.setTitle("Upload", for: .normal)
		uploadButton.snp.makeConstraints { (make) -> Void in
			make.right.equalTo(self).offset(600)
			make.bottom.equalTo(self).offset(-850)
		}
		
		
	}
	
	public func setupView(vm: PreloadedLevelCardViewModel) {
		levelNameLabel.text = vm.levelName
		levelNameLabel.strokedText(strokeColor: vm.levelNameStrokeColor, fontColor: vm.levelNameLabelColor, strokeSize: vm.levelNameStrokeSize, font: vm.levelNameLabelFont!)
		levelNameLabel.font = vm.levelNameLabelFont
		levelNameLabel.textColor = vm.levelNameLabelColor
		
		playerScoreLabel.text = "\(vm.playerScore)%"
		playerScoreLabel.font = vm.playerScoreLabelFont
		playerScoreLabel.textColor = vm.playerScoreLabelColor
		
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
