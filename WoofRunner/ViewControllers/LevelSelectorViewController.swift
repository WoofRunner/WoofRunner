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
	
	var items: [Int] = [1,2,3,4,5]
	@IBOutlet var carousel: iCarousel!

    override func viewDidLoad() {
        super.viewDidLoad()
		carousel.type = .linear
		carousel.stopAtItemBoundary = true
		carousel.bounces = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfItems(in carousel: iCarousel) -> Int {
		return items.count
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		var label: UILabel
		var itemView: UIImageView
		
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
			itemView = UIImageView(frame: frame)
			//itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
			itemView.image = UIImage(named: "testCat.jpg")
			itemView.contentMode = .center
			
			label = UILabel(frame: itemView.bounds)
			label.backgroundColor = .clear
			label.textAlignment = .center
			label.font = label.font.withSize(50)
			label.tag = 1
			itemView.addSubview(label)
		}
		
		//set item label
		//remember to always set any properties of your carousel item
		//views outside of the `if (view == nil) {...}` check otherwise
		//you'll get weird issues with carousel item content appearing
		//in the wrong place in the carousel
		label.text = "\(items[index])"
		
		return itemView
	}
	
	func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
		if (option == .spacing) {
			return value * 1.1
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
