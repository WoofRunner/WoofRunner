//
//  LSItemView.swift
//  WoofRunner
//
//  Created by See Loo Jane on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SnapKit

class LSItemView: UIView {
	
	var controllerDelegate: LSItemDelegate?
	var levelImageView = UIImageView()
	var levelNameLabel = UILabel()
	var playerScoreLabel = UILabel()
	
	var label = UILabel()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		didLoad()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		didLoad()
	}
	
	private func didLoad() {
		
		addSubview(levelNameLabel)
		addSubview(levelImageView)
		//addSubview(playerScoreLabel)
	
		levelNameLabel.sizeToFit()
		playerScoreLabel.sizeToFit()
		
		// Set Constraints for Level Name label
		levelNameLabel.snp.makeConstraints { (make) -> Void in
			make.centerY.equalTo(self)
			make.topMargin.equalTo(30)
			make.bottomMargin.equalTo(30)
		}
		
		// Set Constraints for level image
		levelImageView.snp.makeConstraints { (make) -> Void in
			make.centerY.equalTo(self)
			make.topMargin.equalTo(30)
			make.bottomMargin.equalTo(30)
		}
		
		//addAndConfigureLevelNameLabel()
		//addAndConfigurePlayerScoreLabel()
		//addAndConfigureLevelImage()
		
		/*
		let tap = UITapGestureRecognizer(target: self, action: Selector("tapFunction:"))
		self.addGestureRecognizer(tap)
		*/

	}
	
	
	func tapFunction(sender:UITapGestureRecognizer) {
		controllerDelegate?.onTapItem()
	}
	
	public func setDelegate(_ delegate: LSItemDelegate) {
		self.controllerDelegate = delegate
	}
	
	public func setLevelName(_ name: String) {
		label.text = name
		
	}
	
	public func setupView(vm: LSListItemViewModel) {
		levelNameLabel.text = vm.levelName
		levelNameLabel.font = vm.levelNameLabelFont
		levelNameLabel.textColor = vm.levelNameLabelColor
		
		playerScoreLabel.text = "\(vm.playerScore)%"
		playerScoreLabel.font = vm.playerScoreLabelFont
		playerScoreLabel.textColor = vm.playerScoreLabelColor
		
		levelImageView.image = UIImage(named: vm.levelImageUrl)
		
	}
	
	
}
