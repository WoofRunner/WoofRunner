//
//  MenuViewController.swift
//  WoofRunner
//
//  Created by See Loo Jane on 3/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    // MARK: - IBOutlets

	@IBOutlet weak var customBtn: UIButton!
	@IBOutlet weak var playBtn: UIButton!

    // MARK: - IBActions

    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        // Unwind to menu
    }
	
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
		playBtn.setShadow()
		customBtn.setShadow()
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
