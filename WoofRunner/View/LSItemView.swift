//
//  LSItemView.swift
//  WoofRunner
//
//  Created by See Loo Jane on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

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
		addAndConfigureLevelNameLabel()
		addAndConfigurePlayerScoreLabel()
		addAndConfigureLevelImage()
		
		/*
		let tap = UITapGestureRecognizer(target: self, action: Selector("tapFunction:"))
		self.addGestureRecognizer(tap)
		*/

	}
	
	private func addAndConfigurePlayerScoreLabel() {
		playerScoreLabel.backgroundColor = UIColor.blue
		playerScoreLabel.textAlignment = .center
		playerScoreLabel.textColor = UIColor.white
		playerScoreLabel.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(playerScoreLabel)
		
		let widthConstraint = NSLayoutConstraint(item: playerScoreLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
		let heightConstraint = NSLayoutConstraint(item: playerScoreLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
		var constraints = NSLayoutConstraint.constraints(
			withVisualFormat: "V:[superview]-(<=1)-[label]",
			options: NSLayoutFormatOptions.alignAllCenterX,
			metrics: nil,
			views: ["superview":self, "label":playerScoreLabel]
		)
		
		self.addConstraints(constraints)
		
		// Center vertically
		constraints = NSLayoutConstraint.constraints(
			withVisualFormat: "H:[superview]-(<=1)-[label]",
			options: NSLayoutFormatOptions.alignAllCenterY,
			metrics: nil,
			views: ["superview":self, "label":playerScoreLabel]
		)
		
		self.addConstraints(constraints)
		self.addConstraints([widthConstraint, heightConstraint])
	}
	
	private func addAndConfigureLevelImage() {
		
	}
	
	private func addAndConfigureLevelNameLabel() {
		levelNameLabel.backgroundColor = UIColor.blue
		levelNameLabel.textAlignment = .center
		levelNameLabel.textColor = UIColor.white
		levelNameLabel.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(levelNameLabel)
		
		let widthConstraint = NSLayoutConstraint(item: levelNameLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
		let heightConstraint = NSLayoutConstraint(item: levelNameLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
		var constraints = NSLayoutConstraint.constraints(
			withVisualFormat: "V:[superview]-(<=1)-[label]",
			options: NSLayoutFormatOptions.alignAllCenterX,
			metrics: nil,
			views: ["superview":self, "label":levelNameLabel]
		)
		
		self.addConstraints(constraints)
		
		// Center vertically
		constraints = NSLayoutConstraint.constraints(
			withVisualFormat: "H:[superview]-(<=1)-[label]",
			options: NSLayoutFormatOptions.alignAllCenterY,
			metrics: nil,
			views: ["superview":self, "label":levelNameLabel]
		)
		
		self.addConstraints(constraints)
		self.addConstraints([widthConstraint, heightConstraint])
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
		levelImageView.image = UIImage(named: vm.levelImageUrl)
		playerScoreLabel.text = "\(vm.playerScore)%"
	}
	
	
}
