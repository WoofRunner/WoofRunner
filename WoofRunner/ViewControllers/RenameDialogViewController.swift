//
//  RenameDialogViewController.swift
//  WoofRunner
//
//  Created by See Loo Jane on 4/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

class RenameDialogViewController: UIViewController {
	
	
	@IBOutlet weak var levelNameTextField: UITextField!
	@IBOutlet weak var invalidWarningText: UILabel!
	
	private var levelName: String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Configure TextField
		levelNameTextField.delegate = self
		invalidWarningText.isHidden = true

	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	public func getLevelName() -> String {
		//return self.levelName
		return self.levelNameTextField.text ?? ""
	}
	
	public func showWarningText() {
		invalidWarningText.isHidden = false
	}
	
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

extension RenameDialogViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		//endEditing()
		return true
	}
	
}


