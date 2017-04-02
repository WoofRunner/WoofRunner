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
		
		addSubview(levelImageView)
		addSubview(levelNameLabel)
		addSubview(playerScoreLabel)
	
		levelNameLabel.sizeToFit()
		playerScoreLabel.sizeToFit()
		
		setShadows()
		
		// Set Constraints for level image
		levelImageView.snp.makeConstraints { (make) -> Void in
			make.center.equalTo(self)
			//make.topMargin.equalTo(30)
			//make.bottomMargin.equalTo(30)
		}
		
		// Set Constraints for Level Name label
		levelNameLabel.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.topMargin.equalTo(self).offset(80)
			//make.bottomMargin.equalTo(30)
		}
		
		
		// Set Constraints for Level Name label
		playerScoreLabel.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-80)
			//make.bottomMargin.equalTo(30)
		}
		
	}
	
	public func setupView(vm: LSListItemViewModel) {
		levelNameLabel.text = vm.levelName
		levelNameLabel.font = vm.levelNameLabelFont
		levelNameLabel.textColor = vm.levelNameLabelColor
		
		playerScoreLabel.text = "\(vm.playerScore)%"
		playerScoreLabel.font = vm.playerScoreLabelFont
		playerScoreLabel.textColor = vm.playerScoreLabelColor
		
		let resized = UIImage(named: vm.levelImageUrl)?.resizedImageWithinRect(rectSize: vm.imageRectSize)
		levelImageView.image = resized
		
		// Set Shadows
		setShadows()
	}
	
	// TODO: Check why 1st 2 items do not have shadow rendered. Sth to do with recycling in iCarousel
	private func setShadows() {
		configureImageViewShadow()
		configureLabelShadow()
	}
	
	private func configureLabelShadow() {
		//Set Shadows
		playerScoreLabel.layer.shadowColor = UIColor.black.cgColor
		playerScoreLabel.layer.shadowRadius = 3.0
		playerScoreLabel.layer.shadowOpacity = 0.8
		playerScoreLabel.layer.shadowOffset = CGSize.zero
		playerScoreLabel.layer.masksToBounds = false
	}
	
	private func configureImageViewShadow() {
		// Set Shadows
		levelImageView.layer.shadowColor = UIColor.black.cgColor
		levelImageView.layer.shadowOpacity = 1
		levelImageView.layer.shadowOffset = CGSize.zero
		levelImageView.layer.shadowRadius = 10
		levelImageView.layer.shadowPath = UIBezierPath(rect: levelImageView.bounds).cgPath
	}
	
}