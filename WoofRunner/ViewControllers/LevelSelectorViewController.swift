//
//  LevelSelectorViewController.swift
//  WoofRunner
//
//  Created by See Loo Jane on 11/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import iCarousel

class LevelSelectorViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
	
	var gsm = GameStorageManager.getInstance()
	var levels = [StoredGame]()
	var items: [Int] = [1,2,3,4,5]
	let colorArray = [UIColor.blue, UIColor.brown, UIColor.red, UIColor.green, UIColor.orange]
	@IBOutlet var carousel: iCarousel!

	// - MARK: Lifecycle methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureCarouselView()
		populateLevelData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// - MARK: Init View Methods
	
	private func configureCarouselView() {
		carousel.type = .linear
		carousel.stopAtItemBoundary = true
		carousel.scrollToItemBoundary = true
		carousel.bounces = false
		carousel.decelerationRate = 0.7
	}
	
	private func populateLevelData() {
		self.levels = gsm.getAllGames()
		print("Num of levels: \(self.levels.count)")
	}
	
	func numberOfItems(in carousel: iCarousel) -> Int {
		//return self.levels.count
		//return items.count
		let numLevels = gsm.getAllGames().count
		return numLevels
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		
		
		var levelItemView: LSLevelView
		
		if let view = view as? LSLevelView {
			levelItemView = view
		} else {
			levelItemView = LSLevelView(frame: self.view.frame)
			levelItemView.contentMode = .center
		}
		
		
		/*
		var label = UILabel()
		//var itemView: UIImageView
		var itemView: UIView
		var imageView: UIImageView
		
		
		
		//reuse view if available, otherwise create a new view
		if let view = view as? UIImageView {
			itemView = view
			
			//get a reference to the label in the recycled view
			label = itemView.viewWithTag(1) as! UILabel
		} else {
			
			//don't do anything specific to the index within
			//this `if ... else` statement because the view will be
			//recycled and used with other index values later
			let frame = self.view.frame
			itemView = UIView(frame: frame)
			itemView.contentMode = .center
			//itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
			
			imageView = UIImageView(frame: frame)
			imageView.image = UIImage(named: "testCat.jpg")
			imageView.contentMode = .center
			itemView.addSubview(imageView)
			
			/*
			//label = UILabel(frame: itemView.bounds)
			label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.backgroundColor = .clear
			label.textAlignment = .center
			label.font = label.font.withSize(50)
			label.tag = 1
			label.text = "Hello"
			
			itemView.addSubview(label)
			label.sizeToFit()
			let constraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal,
			                                    toItem: imageView, attribute: .bottom,
			                                    multiplier: 1.0, constant: 0.0)
			
			
			itemView.addConstraint(constraint)
			*/
			
			
			label.backgroundColor = UIColor.blue
			label.textAlignment = .center
			//label.text = "Test"
			label.textColor = UIColor.white
			label.translatesAutoresizingMaskIntoConstraints = false
			itemView.addSubview(label)
			
			let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
			let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
			var constraints = NSLayoutConstraint.constraints(
				withVisualFormat: "V:[superview]-(<=1)-[label]",
				options: NSLayoutFormatOptions.alignAllCenterX,
				metrics: nil,
				views: ["superview":itemView, "label":label]
			)
			
			itemView.addConstraints(constraints)
			
			// Center vertically
			constraints = NSLayoutConstraint.constraints(
				withVisualFormat: "H:[superview]-(<=1)-[label]",
				options: NSLayoutFormatOptions.alignAllCenterY,
				metrics: nil,
				views: ["superview":itemView, "label":label]
			)
						
			itemView.addConstraints(constraints)
			itemView.addConstraints([ widthConstraint, heightConstraint])
		}
		*/
		
		
		//set item label
		//remember to always set any properties of your carousel item
		//views outside of the `if (view == nil) {...}` check otherwise
		//you'll get weird issues with carousel item content appearing
		//in the wrong place in the carousel
		
		//levelItemView.backgroundColor = colorArray[index%5]
		//levelItemView.setLevelName(self.levels[index].uuid!)
		
		if (index%2 == 0) {
			levelItemView.backgroundColor = UIColor.yellow
		} else {
			levelItemView.backgroundColor = UIColor.green
		}
		
		levelItemView.setLevelName("\(levels[index].uuid!)")

		//return itemView
		
		return levelItemView as UIView
	}
	
	func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
		if (option == .spacing) {
			//return value * 1.1
			return 1.0
		}
		
		if (option == iCarouselOption.wrap) {
			return 1.0
		}
		return value
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
