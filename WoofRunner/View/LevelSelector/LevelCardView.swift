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
	*/
	internal func didLoad() {
		initialiseLevelImageView()
		initialiseLevelNameLabel()
		
		// Initialise Extra Child Views
		initialiseCustomChildViews()
	}
	
	
	// MARK: - Public Method
	
	/**
	Setup the view using the input view model object
	
	- parameters:
	- vm: the LevelCardViewModel object to be used to set up the view
	
	*/
	public func setupView(vm: LevelCardViewModel) {
		self.backgroundColor = UIColor.clear
		
		// Setup Child Views
		setupLevelNameLabel(viewModel: vm)
		setupImageView(viewModel: vm)
		
		// Setup Extra Child Views
		setupCustomChildViews(vm: vm)
		
		// Bind current item's UUID to the buttons for callbacks later
		bindUUIDToViews(vm.levelUUID)

	}
	
	// MARK: - Methods to be overriden
	
	/**
	Initialise any additional custom child views
	
	- important:
	Override this method to initialise additional child views
	*/
	internal func initialiseCustomChildViews() {
	}
	
	/**
	Setup any additional custom child views
	
	- important:
	Override this method to setup additional child views
	*/
	internal func setupCustomChildViews(vm: LevelCardViewModel) {
	}
	
	/**
	Binds input UUID to the custom child views as required for their callbacks.
	
	- important:
	Override this method to bind more views to UUID
	*/
	internal func bindUUIDToCustomChildViews(_ uuid: String) {
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
	
	private func bindUUIDToViews(_ uuid: String) {
		levelImageView.bindUUID(uuid)
		bindUUIDToCustomChildViews(uuid)
	}
	
	

}
