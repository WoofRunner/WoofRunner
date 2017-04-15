//
//  CustomLevelViewController.swift
//  WoofRunner
//
//  Created by See Loo Jane on 3/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

class CustomLevelViewController: UIViewController {
	
	
	@IBOutlet weak var createBtn: UIButton!
	@IBOutlet weak var levelsBtn: UIButton!
	@IBOutlet weak var marketplaceBtn: UIButton!
	
	// MARK: - Life Cycle Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureButtonViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Init Views
	
	private func configureButtonViews() {
		createBtn.setShadow()
		levelsBtn.setShadow()
		marketplaceBtn.setShadow()
	}
	
	
	// MARK: - ACTIONS
	
	@IBAction func onTapHome(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
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
