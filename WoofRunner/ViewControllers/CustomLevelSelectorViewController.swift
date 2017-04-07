//
//  CustomLevelSelectorViewController.swift
//  WoofRunner
//
//  Created by See Loo Jane on 8/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//


import UIKit
import iCarousel

class CustomLevelSelectorViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
	
	var gsm = GameStorageManager.getInstance()
	var levels = [StoredGame]()
	
	
	@IBOutlet var carousel: iCarousel!
	@IBOutlet weak var homeButton: UIButton!
	
	// MARK: - Lifecycle methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureCarouselView()
		populateLevelData()
		configureHomeButtonView()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Init View Methods
	
	private func configureCarouselView() {
		carousel.type = .linear
		carousel.stopAtItemBoundary = true
		carousel.scrollToItemBoundary = true
		carousel.bounces = false
		carousel.decelerationRate = 0.7
	}
	
	private func configureHomeButtonView() {
		self.view.bringSubview(toFront: homeButton)
	}
	
	// MARK: - Data retrieval
	
	private func populateLevelData() {
		gsm.getAllGames()
			.onSuccess { games in
				self.levels = games
				self.carousel.reloadData()
				print("\(self.levels.count) games loaded.")
			}
			.onFailure { error in
				print("\(error.localizedDescription)")
				// TODO: Handle error
		}
	}
	
	// MARK: - iCarouselDelegate
	
	func numberOfItems(in carousel: iCarousel) -> Int {
		return levels.count
	}
	
	// Configure item view
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		
		var levelItemView: CustomLevelSelectorCard
		
		// Check for recyled views, else create new
		// NOTE: DO NOT do anything specific to index here
		if let view = view as? CustomLevelSelectorCard {
			levelItemView = view
		} else {
			levelItemView = CustomLevelSelectorCard(frame: self.view.frame)
			levelItemView.contentMode = .center
		}
		
		// Set up view from ViewModel
		let vm = PreloadedLevelCardViewModel(game: levels[index])
		levelItemView.setupView(vm: vm)
		
		// Set Selectors for buttons
		levelItemView.editButton.addTarget(self, action: #selector(editLevelHandler(_:)), for: .touchUpInside)
		// TODO: Selectors for other buttons
		
		// Set up tap gesture for level (Tap image to play game)
		let playTapRecogniser = UITapGestureRecognizer(target: self, action: #selector(playLevelHandler(_:)))
		levelItemView.levelImageView.addGestureRecognizer(playTapRecogniser)
		
		
		return levelItemView as UIView
	}
	
	// Configure Carousel View properties
	func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
		if (option == .spacing) {
			return 1.0
		}
		
		if (option == iCarouselOption.wrap) {
			return 1.0
		}
		return value
	}
	
	// MARK: - TAP LOGIC HANDLERS
	
	func playLevelHandler(_ sender: UITapGestureRecognizer) {
		
		let imageView = sender.view as! LevelSelectorItemImageView
		let uuid = imageView.getBindedUUID()
		
		print("Selected Item To Play: \(uuid)")
		
		self.performSegue(withIdentifier: "segueToGameplay", sender: uuid)
	}
	
	func editLevelHandler(_ sender: UIButton) {
		let btn = sender as! LevelSelectorItemButton
		let uuid = btn.getBindedUUID()
		
		print("Selected Item To Edit: \(uuid)")
		
		gsm.getGame(uuid: uuid)
			.onSuccess { loadedGame in
				self.performSegue(withIdentifier: "segueToLevelDesigner", sender: loadedGame)
			}
			.onFailure { error in
				print("\(error.localizedDescription)")
		}
		
	}
	
	// MARK: - View Setup Methods
	
	
	// MARK: - Actions
	
	@IBAction func onPressHomeBtn(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		
		if segue.identifier == "segueToGameplay" {
			let destination = segue.destination as! GameController
			let uuid = sender as! String
			destination.setGameUUID(uuid)
		}
		
		if segue.identifier == "segueToLevelDesigner" {
			let destination = segue.destination as! LevelDesignerViewController
			let loadedGame = sender as! StoredGame
			destination.loadedLevel = loadedGame
		}
		
	}
	
	
}

