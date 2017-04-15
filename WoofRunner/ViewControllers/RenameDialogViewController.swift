//
//  RenameDialogViewController.swift
//  WoofRunner
//
//  Created by See Loo Jane on 4/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

class RenameDialogViewController: UIViewController {
	
	// MARK: - IBOutlets

	@IBOutlet weak var levelNameTextField: UITextField!
	@IBOutlet weak var invalidWarningText: UILabel!
	
	// MARK: - Private Variables

	private var levelName: String = ""
	
	// MARK: - Life Cycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		invalidWarningText.isHidden = true

	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Public Functions
	
	/**
	Returns the entered level name
	*/
	public func getLevelName() -> String {
		//return self.levelName
		return self.levelNameTextField.text ?? ""
	}
	
	/**
	Shows the warning text for invalid user input
	*/
	public func showWarningText() {
		invalidWarningText.isHidden = false
	}
	
	/**
	Hides the warning text for invalid user input
	*/
	public func hideWarningText() {
		invalidWarningText.isHidden = true
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



