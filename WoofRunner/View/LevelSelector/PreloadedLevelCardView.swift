//
//  PreloadedLevelCardView.swift
//  WoofRunner
//
//  Created by See Loo Jane on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SnapKit

class PreloadedLevelCardView: UIView {

	var levelImageView = LevelSelectorItemImageView() // Public access to set Tap Handler Gesture
	private var levelNameLabel = StrokedLabel()
	private var playerScoreLabel = UILabel()
	
	var editButton = LevelSelectorItemButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // FOR DEBUG ONLY
	
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
			make.bottom.equalTo(self).offset(-80)
		}
		
		// Add and configure debug Edit button
		addSubview(editButton)
		editButton.setTitle("Edit", for: .normal)
		editButton.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-40)
		}
	}
	
	// MARK: - Public Method
	
	// Call this method to setup the View using the input view model object
	public func setupView(vm: LevelCardViewModel) {
		setupLevelNameLabel(viewModel: vm)
		setupScoreLabel(viewModel: vm)
		setupImageView(viewModel: vm)
		
		setShadows()
		self.backgroundColor = UIColor.clear
		
		// Binding current item's UUID to the buttons for callbacks later
		editButton.bindUUID(vm.levelUUID)
		levelImageView.bindUUID(vm.levelUUID)
		
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
	
	private func setupImageView(viewModel: LevelCardViewModel) {
		
		// Resizes the image while keeping the aspect ratio
		let resized = UIImage(named: viewModel.levelImageUrl)?
			.resizedImageWithinRect(rectSize: viewModel.imageRectSize)
		levelImageView.image = resized
		levelImageView.isUserInteractionEnabled = true
	}
	
	// Setup shadows for views
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
