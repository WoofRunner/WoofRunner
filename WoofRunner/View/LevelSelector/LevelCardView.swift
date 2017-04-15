//
//  LevelCardView.swift
//  WoofRunner
//
//  Created by See Loo Jane on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

/**
To be displayed for every item in the level selectors' carousel view
*/
class LevelCardView: UIView {
	
	// MARK: Variables
	
	// Views that are shared across all subclasses of LevelCardView
	var levelImageView = LevelSelectorItemImageView() // Requires public access to set Tap Handler Gesture
	private var levelNameLabel = StrokedLabel()
	
	// MARK: - Initialisers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		didLoad()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		didLoad()
	}
	
	// MARK: - View Init Method
	
	/**
	Initialises the child views that are to be displayed upon loading.
	
	- important:
	Override this method to initialise more customised child views
	*/
	internal func didLoad() {
		initialiseLevelImageView()
		initialiseLevelNameLabel()
	}
	
	
	// MARK: - Public Method
	
	/**
	Setup the view using the input view model object
	
	- parameters:
		- vm: the LevelCardViewModel object to be used to set up the view
	
	- important;
	Override this method if you have more child views to be set up
	
	*/
	public func setupView(vm: LevelCardViewModel) {
		self.backgroundColor = UIColor.clear
		
		// Setup Child Views
		setupLevelNameLabel(viewModel: vm)
		setupImageView(viewModel: vm)
		
		// Bind current item's UUID to the buttons for callbacks later
		bindUUIDToButtons(vm.levelUUID)

	}
	
	// MARK: - Private Helper Methods
	
	private func initialiseLevelImageView() {
		addSubview(levelImageView)
		levelImageView.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.centerY.equalTo(self)
		}
		levelImageView.setShadow()
	}
	
	private func initialiseLevelNameLabel() {
		addSubview(levelNameLabel)
		levelNameLabel.sizeToFit()
		levelNameLabel.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.topMargin.equalTo(self).offset(80)
		}
		levelNameLabel.setShadow()
	}
	
	private func setupLevelNameLabel(viewModel: LevelCardViewModel) {
		levelNameLabel.text = viewModel.levelName
		levelNameLabel.strokedText(strokeColor: viewModel.levelNameStrokeColor,
		                           fontColor: viewModel.levelNameLabelColor,
		                           strokeSize: viewModel.levelNameStrokeSize,
		                           font: viewModel.levelNameLabelFont!)
		levelNameLabel.font = viewModel.levelNameLabelFont
		levelNameLabel.textColor = viewModel.levelNameLabelColor
	}
	
	private func setupImageView(viewModel: LevelCardViewModel) {
		
		// Resizes the image while keeping the aspect ratio
		let resized = UIImage(named: viewModel.levelImageUrl)?
			.resizedImageWithinRect(rectSize: viewModel.imageRectSize)
		levelImageView.image = resized
		levelImageView.isUserInteractionEnabled = true
	}
	
	/**
	Binds input UUID to the buttons in the view as required for their callbacks.
	
	- important:
	Override this method to bind more buttons
	*/
	internal func bindUUIDToButtons(_ uuid: String) {
		levelImageView.bindUUID(uuid)
	}
	
	

}
