//
//  LevelCardView.swift
//  WoofRunner
//
//  Created by See Loo Jane on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

class LevelCardView: UIView {
	
	// Views that are shared across all subclasses of LevelCardView
	var levelImageView = LevelSelectorItemImageView() // Requires public access to set Tap Handler Gesture
	private var levelNameLabel = StrokedLabel()
	private var playerScoreLabel = UILabel()
	
	// MARK: - Initialisers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		didLoad()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		didLoad()
	}
	
	// Override this method to initialise more customised child views
	internal func didLoad() {
		
		// Add child views
		addSubview(levelImageView)
		addSubview(levelNameLabel)
		addSubview(playerScoreLabel)
		
		// Sizing label views
		levelNameLabel.sizeToFit()
		playerScoreLabel.sizeToFit()
		
		setShadows()
		
		//******** Setting Constraints *******//
		
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
	
	}
	
	
	// MARK: - Public Method
	
	// Call this method to setup the View using the input view model object
	// Override this method if you have more child views to be set up
	public func setupView(vm: LevelCardViewModel) {
		self.backgroundColor = UIColor.clear
		
		// Setup Child Views
		setupLevelNameLabel(viewModel: vm)
		setupScoreLabel(viewModel: vm)
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
	
	private func setupImageView(viewModel: LevelCardViewModel) {
		
		// Resizes the image while keeping the aspect ratio
		let resized = UIImage(named: viewModel.levelImageUrl)?
			.resizedImageWithinRect(rectSize: viewModel.imageRectSize)
		levelImageView.image = resized
		levelImageView.isUserInteractionEnabled = true
	}
	
	// Override this method to bind more buttons
	internal func bindUUIDToButtons(_ uuid: String) {
		levelImageView.bindUUID(uuid)
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
